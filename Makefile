
SC = shellcheck
SCFLAGS = --color=always
SHELLSCRIPTS := setup.sh install.sh

shellcheck: $(SHELLSCRIPTS)
	@echo "Running ShellCheck on shell scripts..."
	$(SC) $(SCFLAGS) $(SHELLSCRIPTS)
