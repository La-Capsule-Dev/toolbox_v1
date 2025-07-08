#!/usr/bin/env python3
import gi
gi.require_version('Gdk', '3.0')
from gi.repository import Gdk

dsp = Gdk.Display.get_default()
n_mons = dsp.get_n_monitors()


for i in range(n_mons):
    mon = dsp.get_monitor(i)
    mon_name = mon.get_model()
    w = mon.get_width_mm()/25.4
    h = mon.get_height_mm()/25.4
    d = ((w**2)+(h**2))**(0.5)
    print(("\t").join(['Taille en pouces: ']+[str(round(n, 1)) for n in [d]]))
