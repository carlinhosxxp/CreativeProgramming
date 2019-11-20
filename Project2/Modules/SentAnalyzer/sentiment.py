#!/usr/bin/env python
import nltk

from nltk.metrics import BigramAssocMeasures
from nltk.probability import FreqDist, ConditionalFreqDist
from nltk.corpus import movie_reviews
from nltk.tokenize import word_tokenize
from nltk.classify import NaiveBayesClassifier
from nltk.corpus.util import LazyCorpusLoader
from nltk.corpus.reader import CategorizedPlaintextCorpusReader

from operator import itemgetter
import random

POSITIVE = 'pos'
NEGATIVE = 'neg'

class SentAnalyzer:

    def __init__(self):
        """
            Method to initialize the SentimentAnalyzer
        """
        self._split_ratio = 1.0
        self._corpusName = 'movie_reviews'
        self._classfier = None
        self._corpus = None
        self._trainingFiles = {}
        self._testFiles = {}
        self._words_info = {}
        

    def __getstate__(self):
        state = self.__dict__.copy()
        state['_corpus'] = None
        state['_testFiles'] = {}
        state['_trainingFiles'] = {}
        return state

    def __setstate__(self, state):
        self.__dict__ = state


    @property   
    def split_ratio(self):
        return self._split_ratio
    
    @split_ratio.setter
    def split_ratio(self, value):
        self._split_ratio = value

    @property
    def corpus(self):
        """
            This method is used to initialize the corpus object if it wasn't before
        """
        if self._corpus is None:
            # The use of r'(?!\.).*\.txt' and =r'(neg|pos)/.*' makes possible to find the files labeled with neg and pos
            self._corpus = LazyCorpusLoader(self._corpusName, CategorizedPlaintextCorpusReader, r'(?!\.).*\.txt', cat_pattern=r'(neg|pos)/.*', encoding='ascii' )

        return self._corpus
    
    @corpus.setter 
    def corpus(self, value):
        self._corpus = value


    def setData(self):
        """
            This method split the data accordingly with the label pre-settled in the corpus (pos, neg)
        """
       
        pos = set(self.corpus.fileids(POSITIVE))
        neg = set(self.corpus.fileids(NEGATIVE))

        positive_testSize = int(len(pos) * (1 - self.split_ratio)) # Number of positive labled files dedicated for test
        negative_testSize = int(len(neg) * (1 - self.split_ratio)) # Number of negative labled files dedicated for test

        self._testFiles[POSITIVE] = set(random.sample(pos, positive_testSize))
        self._testFiles[NEGATIVE] = set(random.sample(neg, negative_testSize))

        self._trainingFiles[POSITIVE] = pos - self._testFiles[POSITIVE]
        self._trainingFiles[NEGATIVE] = neg - self._testFiles[NEGATIVE]

    def scoreCalculation(self, frequency, cond_frequency, n_positive, n_negative, n_total):
        """
            Calculate the score for the words
        """
        final_score = {}
        for word, _freq in frequency.items():
            final_score[word] = 0 # initiate the score for that word

            positive_frequency = cond_frequency[POSITIVE][word] # Take the frequency of positive words
            score = BigramAssocMeasures.chi_sq(positive_frequency, (_freq, n_positive), n_total) # Get the score of positive founded
            final_score[word] += score # Sum the final score for that word
            negative_frequency = cond_frequency[NEGATIVE][word]
            score = BigramAssocMeasures.chi_sq(negative_frequency, (_freq, n_negative), n_total)
            final_score[word] += score

        return final_score

    def extractWordInformations(self):
        frequency = FreqDist()
        #print(type(frequency))
        cond_frequency = ConditionalFreqDist()

        # Get all of the words in positive labled files and count the appearence frequency
        for word in self.corpus.words(categories=POSITIVE):
            word = word.lower()
            frequency[word] += 1
            cond_frequency[POSITIVE][word] += 1

        # Get all of the words in negative labled files and count the appearence frequency
        for word in self.corpus.words(categories=NEGATIVE):
            word = word.lower()
            frequency[word] += 1
            cond_frequency[NEGATIVE][word] += 1

        # Get the number of positive and negative 
        n_positive = cond_frequency[POSITIVE].N()
        n_negative = cond_frequency[NEGATIVE].N()

        # Get the total number of positive and negative 
        n_total = n_positive + n_negative

        # Calculate the final score por each word
        final_score = self.scoreCalculation(frequency, cond_frequency, n_positive, n_negative, n_total)

        scoreSorted_words = []
        for word, _ in sorted(final_score.items(), key = itemgetter(1), reverse=True):
            scoreSorted_words.append(word)

        self._words_info = set(scoreSorted_words[:10000])

    def extractFeatures(self, sentence):
        words = []
        for word in word_tokenize(sentence):
            if word in self._words_info:
                words.append(word.lower())
        return {word : True for word in words}

    def train(self):
        self.setData()
        self.extractWordInformations()
        # Extract the instance of positive features
        poisitive_instances = []
        for file in self._trainingFiles[POSITIVE]:
            poisitive_instances.append((self.extractFeatures(self.corpus.raw(fileids=[file])), POSITIVE))

        # Extract the instance of negative features
        negative_instances = []
        for file in self._trainingFiles[NEGATIVE]:
            negative_instances.append((self.extractFeatures(self.corpus.raw(fileids=[file])), NEGATIVE))

        instances = poisitive_instances + negative_instances
        self._classifier = NaiveBayesClassifier.train(instances)
    
    def analyze(self, sentence):
        """
            Method that evaluate a given sentence
            This will return a string containing 'pos' or 'neg'
        """
        features = self.extractFeatures(sentence)
        return self._classifier.classify(features)
    
    def accuracy(self):
        # Extract the instance of positive features
        poisitive_instances = []
        for file in self._trainingFiles[POSITIVE]:
            poisitive_instances.append((self.extractFeatures(self.corpus.raw(fileids=[file])), POSITIVE))

        # Extract the instance of negative features
        negative_instances = []
        for file in self._trainingFiles[NEGATIVE]:
            negative_instances.append((self.extractFeatures(self.corpus.raw(fileids=[file])), NEGATIVE))

        instances = poisitive_instances + negative_instances

        return nltk.classify.accuracy(self._classifier, instances) 

def test():
    a = SentAnalyzer()
    a.split_ratio = 0.9
    a.train()
    print ('Accuracy: {}'.format(a.accuracy()))
        

if __name__ == '__main__':
    test()
