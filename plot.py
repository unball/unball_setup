import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style
from time import sleep

style.use('seaborn-pastel')

fig = plt.figure()
ax1 = fig.add_subplot(2,1,2)
ax2 = fig.add_subplot(2,2,1)
ax3 = fig.add_subplot(2,2,2)

def animate(i):
	robot = 0


	for attempt in range(100):
		try:
			graph_data = open('out.csv','r').read()
			robot_data = open('robot1.txt','r').read()


			lines = graph_data.split('\n')
			lines = lines[1:-1]
			if len(lines)>1000:
				lines = lines[-1000:-1]

			rlines = robot_data.split('\n')
			if len(rlines)>1000:
				rlines = rlines[-1000:-1]

			xs = []
			ys = []

			dx = []
			dy = []

			for line in lines:
				s = line.split(',')
				xs.append(s[robot + 1])
				ys.append(s[robot + 7])

			for rline in rlines:
				t = rline.split(',')
				dx.append(t[0])
				dy.append(t[1])


			ax1.clear()
			ax2.clear()
			ax3.clear()
			ax1.plot(xs,ys)
			ax1.set_ylim([-0.65,0.65])
			ax1.set_xlim([-0.75,0.75])
			ax1.set_title('Path followed by robot')
			ax2.plot(dx)
			plt.hold('on')
			ax2.plot(xs)
			ax2.set_ylim([-0.75,0.75])
			ax2.set_title('Actual and desired x')
			ax2.legend(['Desired x','Actual x'])
			ax3.plot(dy)
			ax3.set_ylim([-0.65,0.65])
			plt.hold('on')
			ax3.plot(ys)
			ax3.set_title('Actual and desired y')
			ax3.legend(['Desired y','Actual y'])
		except:
			sleep(2)
		else:
			break

ani = animation.FuncAnimation(fig, animate, interval = 1000)
plt.show()