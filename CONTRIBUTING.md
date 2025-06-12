# Develop locally
You need `python@3.11`, your best bet is to use the [uv](https://github.com/astral-sh/uv):

* select pinned version `uv python install`
* create a virtual env `uv venv`
* and activate it with `source .venv/bin/activate`
* setup deps: `uv pip install -r requirements-docs.txt`

## Developing
* building: `python ./scripts/docs.py build`
* preview (above) build: `python ./scripts/docs.py serve` -> [http://127.0.0.1:8008/](http://127.0.0.1:8008/)
* live-editing `python ./scripts/docs.py live` -> -> [http://127.0.0.1:8008/](http://127.0.0.1:8008/)
