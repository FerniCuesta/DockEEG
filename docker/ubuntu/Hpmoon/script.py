import sys
import os
import json
import subprocess as sp
import time
import uuid

from time import time as tm

def main():
	number_of_supopulations = [8]
	subpopulation_size = [480]
	threads = int(sp.getoutput('grep -c ^processor /proc/cpuinfo'))
	vampire_id = sp.getoutput('echo $VAMPIRE_ID')
	experiment_name = sp.getoutput('echo $EXPERIMENT_NAME')
	repetitions = 5
	
	user = 'docker_jcr'
	os.system("touch data.json")
	
	directory = r"results_{}_{}".format(vampire_id, experiment_name)
	os.system(r"mkdir {}".format(directory))
	

	for ns in number_of_supopulations:
		for ss in subpopulation_size:
			for t in range(1,threads+1):
				data_array = []
				for e in range(repetitions):
					experiment_id = r"{}_{}ns_{}ss_{}cth_{}rep".format(uuid.uuid1().hex, ns, ss, t, e)
					
					start_time = tm()
					os.system(r"python3 vampire.py start -u {} -e {}".format(user, experiment_id))
					
					os.system(r"mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./bin/hpmoon -conf config.xml -ns {} -ss {} -cth {}".format(ns, ss, t))
					
					os.system(r"python3 vampire.py stop -u {} -e {}".format(user, experiment_id))
					end_time = tm()
					data_array.append([end_time-start_time, experiment_id])
				
				data_file = open(r"{}/{}_{}_{}.txt".format(directory, ns, ss, t), "w")
				for element in data_array:
					data_file.write(r"{},{}".format(element[0], element[1]) + "\n")
				
				data_file.close()
	os.system(r"tar -cf {}.tar {}/".format(directory, directory))
		
					
if __name__ == "__main__":
	main()
