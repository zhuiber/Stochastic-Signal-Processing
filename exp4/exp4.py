from urllib.request import urlopen
from random import randint

def wordListSum(wordList):
    total_sum = 0
    for word, value in wordList.items():
        total_sum += value
    return total_sum

def retrieveRandomWord(wordList):
    randIndex = randint(1, wordListSum(wordList))
    for word, value in wordList.items():
        randIndex -= value
        if randIndex <= 0:
            return word

def buildWordDict(text):
    # 把换行和引号除去
    text = text.replace('\n', ' ')
    text = text.replace('"', '')

    # 所有标点符号都变成空格 则能够提取单词
    punctuation = [',', '.', ';', ':']
    for symbol in punctuation:
        text = text.replace(symbol, ' {} '.format(symbol))

    words = text.split(' ')
    # Filter out empty words
    words = [word for word in words if word != '']

    wordDict = {}
    for i in range(1, len(words)):  # 获得一个二维字典（详细分析在后面）
        if words[i - 1] not in wordDict:
            # Create a new dictionary for this word
            wordDict[words[i - 1]] = {}
        if words[i] not in wordDict[words[i - 1]]:
            wordDict[words[i - 1]][words[i]] = 0

        # Give punctuation marks a weight of 3
        if words[i] in punctuation:
            wordDict[words[i - 1]][words[i]] += 3
        else:
            wordDict[words[i - 1]][words[i]] += 1
    return wordDict

text = str(urlopen('http://pythonscraping.com/files/inaugurationSpeech.txt').read(), 'utf-8')
wordDict = buildWordDict(text)

# 以"I"开头生成一个100单词的马尔可夫链 
length = 100
chain = ['I']
for i in range(0, length):
    newWord = retrieveRandomWord(wordDict[chain[-1]])
    chain.append(newWord)

print(' '.join(chain))
