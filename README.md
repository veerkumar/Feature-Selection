# Feature-Selection
This project is about feature selection for the classification problem on a dataset of high dimensional feature space. We have seen how to project all the features to a lower dimensional space using FDA. Select a subset of features based on some evaluation criteria, In feature selection, we do not project all features by any transformations but rather try different combinations of the original features and choose the feature subset (subspace) that works best for our classification problem. Two key components of feature selection are:

1) A search strategy to go through the feature list and select a subset and

2) An evaluation function to measure the discriminative power of the selected feature subset.

More specifically, you need

    Selection criterion:  the variance ratio (VR) or augmented variance ratio (AVR) where higher value indicates higher discriminative power of the feature (for a formal definition).
    A ranking subroutine: it ranks all the features based on the feature discriminative power criterion and report/display the ranking.
    Build a wrapper based Sequential Forward Selection algorithm.
    Choose your own criterion to optimize, for example maximize the overall classification or minimize the false positive rate. 
    Evaluate the performance using cross validation or random splitting many times (10-100 times).  Report on both the training rates and the average rates + std of test data sets.
