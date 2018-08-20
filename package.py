name = "rezfunk"

version = "0.3.0"

authors = [
    "jgerber"
]

description = \
    """
    cmake functions
    """

tools = [
]

requires = [
]
build_requires = [
    "cmake"
]
uuid = "repository.rezFunk"

def commands():
    if building:
        env.CMAKE_MODULE_PATH.append("{root}/cmake")
