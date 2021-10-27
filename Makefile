package: *.sh *.py mirrors_list.txt
	echo "mkdir -p /tmp/mirrors_helper" > mirrors_helper
	echo 'tail -n+5 $$0 |tar -xz -C /tmp/mirrors_helper' >> mirrors_helper
	echo "chmod +x /tmp/mirrors_helper/mirrors.sh && /tmp/mirrors_helper/mirrors.sh" >> mirrors_helper
	echo 'exit 0' >> mirrors_helper
	tar -cz *.sh *.py mirrors_list.txt >> mirrors_helper
	chmod +x mirrors_helper