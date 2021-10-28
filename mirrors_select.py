#!/usr/bin/env python3
import requests
from tabulate import tabulate
import sys
from os.path import expanduser
home = expanduser("~")
def get_latency (url) :
    result = requests.get(url)
    return "%.1f ms" % (result.elapsed.total_seconds() * 1000)

def progressbar (inlist, length, char_per_item=1, text=""):
    toolbar_width=length*char_per_item
    sys.stdout.write(text+"[%s]" % ("-" * toolbar_width))
    sys.stdout.flush()
    sys.stdout.write("\b" * (toolbar_width+1)) # return to start of line, after '['

    for i in inlist:
        sys.stdout.write("*"*char_per_item)
        sys.stdout.flush()
        yield i

    sys.stdout.write("]\n")


with open('mirrors_list.txt','r') as f:
    mirror_sites=f.readlines()
    res=[("序号","镜像站","延迟")]
    for index, site in progressbar(enumerate(mirror_sites), len(mirror_sites), text="正在测试延迟..."):
        site=site.strip()
        res.append((index+1, site, get_latency(site)))
    print(tabulate(res, headers='firstrow'))

    print(f"请选择你想要的镜像站 [1-{len(res)-1}]：")
    while True:
        try: 
            choice = int(input())
            if choice>0 and choice<len(res):
                break
        except KeyboardInterrupt:
            exit(0)
        except:
            print(f"输入有误，请重新输入 [1-{len(res)-1}]：")
            pass

    with open(home+'/.mirrors_selected.txt', 'r') as f:
        lines=f.readlines()
    lines[0]=res[choice][1]+"\n"
    with open(home+'/.mirrors_selected.txt', 'w') as f:
        f.writelines(lines)
    
    print(f'镜像成功修改为 {res[choice][1]}')

