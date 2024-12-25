from kivy.app import App
from kivy.core.window import Window
from kivy.uix.boxlayout import BoxLayout
import kivy


class MyRoot(BoxLayout):

    def __int__(self):
        super(MyRoot,self).__init__()

class NeuralCalc(App):

    def build(self):
        return MyRoot()

neuralcalc = NeuralCalc()
neuralcalc.run()

#Incomplete tutorial