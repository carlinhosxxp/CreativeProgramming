#!/usr/bin/env python
import sys
import pickle
from Modules.SentAnalyzer.sentiment import SentAnalyzer
from Modules.Connection.connector import Connect, Msg
import speech_recognition as sr 
import pyaudio
import os

'''
    ‘Thoughts are the shadows of our feelings-always darker, emptier, and simpler’. Nietzsche, The gay science p. 203. 
'''

def main_microphone():
    a = SetPersistentClassifier()
    print("Welcome to SentAnalyzer\nDescribe your feelings to me, and I will tell you if it's bad or good")
    r = sr.Recognizer()
    c = Connect()

   
    try:
        with sr.Microphone() as source:
            while True :
                try:
                    audio = r.listen(source,timeout=3, phrase_time_limit=3)
                
                    sentence = r.recognize_google(audio)
                    print('You said: {}'.format(sentence))
                    if sentence.strip().lower() in ['exit', 'quit']:
                        break

                    if sentence.strip().lower() not in ["hello", "hi", "what's up", "hey", "what's your name", "your name", "name", "how are you"]:
                        sentiment = a.analyze(sentence)
                        if sentiment == 'pos':
                            c.write(Msg.happiness, sentence)
                            print("Psychorobot: This is good\n")
                        elif sentiment == 'neg':
                            c.write(Msg.sadness, sentence)
                            print("Psychorobot: This is bad\n")
                            

                    elif sentence.strip().lower() in ["hello", "hi", "what's up", "hey"]:
                        print("Psychorobot: Hey!\n")
                        c.write(Msg.simple_msg, sentence)

                    elif sentence.strip().lower() in ["what's your name", "your name", "name", "what is your name"]:
                        print("Psychorobot: My name is Psychorobot\n")
                        c.write(Msg.simple_msg, sentence)

                    elif sentence.strip().lower() in ["how are you"]:
                        print("Psychorobot: I am angry and tired\n")
                        c.write(Msg.simple_msg, sentence)

                 
                except Exception as e:
                    pass
    except KeyboardInterrupt:
        pass       

def main_text():
    a = SetPersistentClassifier()
    print("Welcome to SentAnalyzer\nDescribe your feelings to me, and I will tell you if it's bad or good")
    c = Connect()
    try:
        while True :
            sentence = input()
            print('You said: {}'.format(sentence))
            if sentence.strip().lower() in ['exit', 'quit']:
                break

            if sentence.strip().lower() not in ["hello", "hi", "what's up", "hey", "what's your name", "your name", "name", "how are you"]:
                sentiment = a.analyze(sentence)
                if sentiment == 'pos':
                    c.write(Msg.happiness, sentence)
                    print("Psychorobot: This is good\n")
                elif sentiment == 'neg':
                    c.write(Msg.sadness, sentence)
                    print("Psychorobot: This is bad\n")
                    

            elif sentence.strip().lower() in ["hello", "hi", "what's up", "hey"]:
                print("Psychorobot: Hey!\n")
                c.write(Msg.simple_msg, sentence)

            elif sentence.strip().lower() in ["what's your name", "your name", "name", "what is your name"]:
                print("Psychorobot: My name is Psychorobot\n")
                c.write(Msg.simple_msg, sentence)

            elif sentence.strip().lower() in ["how are you"]:
                print("Psychorobot: I am angry and tired\n")
                c.write(Msg.simple_msg, sentence)
            
    except KeyboardInterrupt:
        c.initData()
        pass       

def SetPersistentClassifier():
    try:
        with open('SentAnalyzer.classifyer', 'rb') as file:
            a = pickle.load(file)
    except (IOError, pickle.PickleError):
        print ("First use of the analyzer\nPlease wait until the classifier is trained")
        a = SentAnalyzer()
        a.train()
        print("Training concluded with {} of accuracy".format(a.accuracy()))
        with open('SentAnalyzer.classifyer', 'wb') as file:
            pickle.dump(a, file)
    return a

if __name__ == '__main__':
    main_microphone()
    #main_text()
