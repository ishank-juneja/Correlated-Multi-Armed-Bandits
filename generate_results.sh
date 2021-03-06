#!/bin/bash
for instance in instances/*.txt; do
	# Checks if a file like instance
	# actually exists or is just a glob	
	[ -e "$instance" ] || continue
	# Plot arm functions
	echo -e $"Visualizing instance functions $instance\n"
	python3 AoI_instance_plotter.py -i "$instance"
	# python3 instance_plotter.py -i "$instance"
	# Slow step so check if output file already exists
	out_name="results/$(basename "$instance" .txt)-out.txt"
	# echo $out_name	
	if [ -f "$out_name" ]; then
		echo -e $"Results for instance $instance exist, ... skipping simulation\n"
	else
	echo -e $"Currently Simulating Policies on $instance\n"
	# Simulate AoI aware as well	
	 python3 simulate_policies.py -i "$instance" -STEP 100 -horizon 1e4 -nruns 200 --AoI_aware  > "$out_name"
	# Simulate only non AoI-aware policies
	 python3 simulate_policies.py -i "$instance" -STEP 500 -horizon 1e4 -nruns 200  > "$out_name"
	fi
	echo -e $"Plotting Simulation results for $instance \n"
	# python3 regret_plotter.py -i "$out_name" -STEP 500 -horizon 1e4
	# Plot with different step sizes to compare
    python3 regret_plotter_custom.py -i "$out_name" -STEP 100 -horizon 1e4
	python3 regret_plotter_custom.py -i "$out_name" -STEP 200 -horizon 1e4
	python3 regret_plotter_custom.py -i "$out_name" -STEP 500 -horizon 1e4
done
