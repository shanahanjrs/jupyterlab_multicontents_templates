PATH := $(CURDIR)/venv/bin:$(PATH)
.PHONY: venv watch build check-install clean new-build link

# if no venv then create, install the packages needed to install the main package, then install main package
venv:
	if [ ! -d venv ]; then \
		python3 -m venv venv;\
	fi
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -e ".[dev]"


# This incorporates the required steps from 'make venv', 'make build' and the build instructions from the README
new-build:
	if [ ! -d venv ]; then \
		python3 -m venv venv;\
	fi
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
	venv/bin/pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org ".[dev]"
	jlpm run install:extension
	venv/bin/jupyter labextension develop . --overwrite
	jlpm run build

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


check-install:
	jupyter server extension list 2>&1 | grep -ie "jupyterlab_multicontents_templates.*OK"
	jupyter labextension list 2>&1 | grep -ie "jupyterlab_multicontents_templates.*OK"


clean:
	venv/bin/jlpm run clean:all || echo 'not cleaning jlpm'
	rm -rf venv node_modules *.egg-info
