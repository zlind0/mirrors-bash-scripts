package: *.sh *.py mirrors_list.txt
	echo "mkdir -p /tmp/mirrors-helper" > mirrors-helper
	echo 'tail -n+5 $$0 |tar -xz -C /tmp/mirrors-helper' >> mirrors-helper
	echo "chmod +x /tmp/mirrors-helper/mirrors.sh && /tmp/mirrors-helper/mirrors.sh" >> mirrors-helper
	echo 'exit 0' >> mirrors-helper
	tar -cz *.sh *.py mirrors_list.txt >> mirrors-helper
	chmod +x mirrors-helper