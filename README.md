# tox

Image for running [tox](https://tox.readthedocs.org/en/latest/) with multiple
Python and PyPy versions.

Contains all supported Python and PyPy versions.

* Python 3.7
* Python 3.8
* Python 3.9
* Python 3.10
* Python 3.11
* PyPy 3.8
* PyPy 3.9

Image is automatically updated every month with the latest Python versions.
Before pushing to Docker hub, the image is tested on a simple project to make
sure that the updates did not break something.

## Example usage

```sh
docker run --rm -v $PWD:/workdir -w /workdir -u $(id -u) fpob/tox
```
