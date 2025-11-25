define HELPTEXT
General utilities for simple vivado FPGA projects - targets:
  vivado:
    Create a temporary directory to open an instance of vivado in. This keeps temporary
    and project files contained, s.t. they don't pollute git repo and can be easily
    cleaned up if desired.

  vivclean:
    If a temp directory was created to instance vivado - clean it up. This is destructive
    so make sure your source files are stored elsewhere.
endef
export HELPTEXT

.PHONY: help
help:
	@echo "$$HELPTEXT"

.PHONY: vivado
vivado:
	@mkdir -p viv-instance
	@cd viv-instance; vivado;

.PHONY: vivclean
vivclean:
	@rm -rf ./viv-instance;

# TODO: Make may not be the right tool. Perhaps shell scripts are better.
