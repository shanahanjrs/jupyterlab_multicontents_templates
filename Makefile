PATH := $(CURDIR)/venv/bin:$(PATH)
.PHONY: venv watch build clean

# if no venv then create, install the packages needed to install the main package, then install main package
venv:
	if [[ ! -d venv ]]; then \
		python3 -m venv venv;\
	fi
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r pre-setup-requirements.txt
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -e ".[dev]"


watch: venv
	venv/bin/jlpm run watch&
	venv/bin/jupyter lab --debug \
		--autoreload \
		--config=examples/jupyter_config.py \
		--no-browser


build: venv
	venv/bin/jlpm run build
	venv/bin/jlpm run install:extension
	venv/bin/jupyter lab build

clean:
	venv/bin/jlpm run clean:all || echo 'not cleaning jlpm'
	rm -rf venv node_modules *.egg-info
