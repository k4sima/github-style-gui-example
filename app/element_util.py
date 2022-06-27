from .main import *


class Progress():
    def __init__(self, list, emit: Callable[[float], None]) -> None:
        self.emit = emit

        self.iter = iter(list)
        self.max = len(list)
        self.val = 0

        self.emit(0)

    def __iter__(self):
        return self

    def __next__(self):
        self.val += 1
        self.emit(self.val / self.max)

        if self.val > self.max:
            self.emit(1)
            raise StopIteration()

        return self.iter.__next__()
