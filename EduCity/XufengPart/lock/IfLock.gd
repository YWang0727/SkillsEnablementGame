extends Node

#0-->lock     1-->unlock
#var Residential:int = 1
#var Supermarket:int = 0
#var Bank:int = 0
#var Construction_Site:int = 0
#var Hospital:int = 0
#index order  
#0-->Residential
#1-->Supermarket
#2-->Bank
#3-->Fram
#4-->Construction_Site
#5-->Hospital

var if_lock:Array = [1,1,1,1,1,1]

var mapDict = {}
