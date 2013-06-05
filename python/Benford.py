#!/usr/bin/env python
# Python 3.3.2
# http://en.wikipedia.org/wiki/Benford%27s_law

# Number |  Times  |  Frequency |  Benford's Law
#      1 |   4168  |    42.41%  |   30.10%
#      2 |   1662  |    16.91%  |   17.61%
#      3 |    945  |     9.61%  |   12.49%
#      4 |    867  |     8.82%  |    9.69%
#      5 |    665  |     6.77%  |    7.92%
#      6 |    388  |     3.95%  |    6.69%
#      7 |    452  |     4.60%  |    5.80%
#      8 |    391  |     3.98%  |    5.12%
#      9 |    291  |     2.96%  |    4.58%

from collections    import defaultdict
from re             import compile
from math           import log10

from urllib.request import Request, urlopen

from queue          import Queue, Empty
from threading      import Thread, Event

class Benford:
    def __init__(self, size=10):
        self.tasks   = Queue()
        self.results = Queue()
        self.halt    = Event()
        self.stat    = defaultdict(int)
        self.workers = list(map(lambda _: Thread(target=self.__worker_loop),
                                range(size)))
        self.master  = Thread(target=self.__master_loop)

    def enqueue(self, url, level=1):
        if level > 0:
            self.tasks.put((url, level))

    def start(self):
        for w in self.workers:
            w.start()
        self.master.start()

    def join(self):
        self.tasks.join()

    def stop(self):
        self.halt.set()

    def show(self):
        items = list(self.stat.items())
        items.sort()
        count = sum(self.stat.values())
        print(" Number |  Times  |  Frequency |  Benford's Law")
        for k, v in items:
            print("%7d | %6d  |   %6.2f%%  |  %6.2f%%" %
                  (k   , v    , v/count * 100, log10(1+1/k) * 100))

    def __worker_loop(self):
        while not self.halt.is_set():
            try:
                url, level = self.tasks.get(True, 0.1)
                if level > 0:
                    for link in self.__process(url):
                        self.enqueue(link, level - 1)
                self.tasks.task_done()
            except Empty:
                continue

    def __master_loop(self):
        while not self.halt.is_set():
            try:
                stat = self.results.get(True, 0.1)
                for k, v in stat.items():
                    self.stat[k] += v
                self.results.task_done()
                self.show()
            except Empty:
                continue

    def __process(self, url):
        request = Request(url)
        request.add_header('User-Agent', 'Python 3')
        print("Requesting " + url)
        links, stat = self.__parse(str(urlopen(request).read()))
        self.results.put(stat)
        return links

    def __parse(self, html):
        numbers = compile('\d+\.?\d*'  ).findall(html)
        links   = compile('href="(http://.+?)"').findall(html)
        stat    = defaultdict(int)
        for n in numbers:
            d = int(str(float(n))[0])
            if d != 0:
                stat[d] += 1
        return (links, stat)

if __name__ == '__main__':
    ben = Benford()
    ben.enqueue('http://github.com/', level=2)
    ben.start()
    ben.join()
    ben.stop()
