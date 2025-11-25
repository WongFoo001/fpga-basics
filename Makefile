define HELPTEXT
General utilities for simple vivado FPGA projects - targets:
  vivado:
    Create a temporary directory to open an instance of vivado in. This keeps temporary
    and project files contained, s.t. they don't pollute git repo and can be easily
    cleaned up if desired.

  viv-clean:
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

.PHONY: viv-clean
viv-clean:
	@if [ -d "./viv-instance" ]; then rm -rf ./viv-instance; fi
