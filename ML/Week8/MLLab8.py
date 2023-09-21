import pandas as pd
#define function for Bayes theorem
def bayesTheorem(pA, pB, pBA):
    return pA * pBA / pB
#define probabilities
pRain = 0.2
pCloudy = 0.4
pCloudyRain = 0.85
#use function to calculate conditional probability
#print(bayesTheorem(pRain, pCloudy, pCloudyRain))


#Q1a)

pH, pD = 0.6, 0.4
pAH, pAD = 0.3, 0.2

def bayesTheorem2(ph,pd,pah,pad):
    return (ph*pah)/(ph*pah + pd*pad)

pHA = bayesTheorem2(pH,pD,pAH,pAD)
prob = round(pHA,5)
#print(prob*100)

#Sensitivity = TP/(TP + FN) and Specificity = TN/(TN + FP) and 1- Specificity = FP/(TN+ FP)
#1b)
pD, pN = 0.01, 0.99 #p(Disease),p(No Disease)
pTD, pTN = 0.99, 0.02 # p(Correct identification of disease), p(Result is positive given no disease) 
pDT = None #p(Having Disease given positive test result)

def bayes(pd,pn,ptd,ptn):
    return (pd*ptd)/(pd*ptd + pn*ptn)

pDT = bayes(pD,pN,pTD,pTN)
prob = round(pDT,4)
#print(f"Probability = {prob*100}%")

import pandas as pd
data = pd.read_csv("data.csv")
print(data.shape)

class NaiveBayesClassifier:
    def __init__(self,X,y):
        self.X,self.y = X,y
        self.N = len(self.X) # Length of the training set
        self.dim = len(self.X[0]) # Dimension of the vector of features
        self.attrs = [[] for _ in range(self.dim)] # Here we'll store the columns of the training set

        self.output_dom = {} # Output classes with the number of ocurrences in the training set. In this case we have only 2 classes

        self.data = [] # To store every row [Xi, yi]
        
        for i in range(len(self.X)):
            for j in range(self.dim):
                # if we have never seen this value for this attr before, 
                # then we add it to the attrs array in the corresponding position
                if not self.X[i][j] in self.attrs[j]:
                    self.attrs[j].append(self.X[i][j])
                    
            # if we have never seen this output class before,
            # then we add it to the output_dom and count one occurrence for now
            if not self.y[i] in self.output_dom.keys():
                self.output_dom[self.y[i]] = 1
            # otherwise, we increment the occurrence of this output in the training set by 1
            else:
                self.output_dom[self.y[i]] += 1
            # store the row
            self.data.append([self.X[i], self.y[i]])
        
    def classify(self, entry):
        solve = None # Final result
        max_arg = -1 # partial maximum

        for y in self.output_dom.keys():

            prob = self.output_dom[y]/self.N # P(y)

            for i in range(self.dim):
                cases = [x for x in self.data if x[0][i] == entry[i] and x[1] == y] # all rows with Xi = xi
                n = len(cases)
                prob *= n/self.N # P *= P(Xi = xi)
                
            # if we have a greater prob for this output than the partial maximum...
            if prob > max_arg:
                max_arg = prob
                solve = y

        return solve


y = list(map(lambda v: 'Yes' if v == 1 else 'no', data['Play'].values)) # target values as string
X = data[['Outlook']].values

y_train = y[:8]
y_val = y[8:]

X_train = X[:8]
X_val = X[8:]

nbc = NaiveBayesClassifier(X_train, y_train)

total_cases = len(y_val) # size of validation set

# Well classified examples and bad classified examples
tp,tn,fp,fn = 0,0,0,0
for i in range(total_cases):
    predict = nbc.classify(X_val[i])
#     print(y_val[i] + ' --------------- ' + predict)
    if y_val[i] == predict:
        if y_val[i] == 'no':
            tn += 1
        else:
            tp += 1
    else:
        if y_val[i] == 'no':
            fn += 1
        else:
            fp += 1

good = tp + tn
bad = fp + fn
print('TOTAL EXAMPLES:', total_cases)
print('RIGHT:', good)
print('WRONG:', bad)
print('ACCURACY:', good/total_cases)
try:
    print('PRECISION:',tp/(tp+fp))
    print('RECALL:',tp/(tp+fn))
except ZeroDivisionError:
    pass