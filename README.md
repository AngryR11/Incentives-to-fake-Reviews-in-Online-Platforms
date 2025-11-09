---
output:
  html_document: default
  pdf_document: default
---
# Read me

This repository contains the targeted dataset used in "Incentives to fake reviews in Online Platforms" by Gustavo Q. Saraiva

As explained in the article, products from the targeted dataset correspond to those from sellers that were soliciting fake reviews on Facebook or Rapidworkers. A few products were also targeted because they were being flagged as suspicious in Amazon seller forums.

The dataset was collected between 2017 and 2018. In a few instances, the same product was scraped more than once, so, it may include some reviews that may have been removed afterwards by Amazon.


# Variable description:
- **review_text**: the review written by the author.
- **review_title**: the title/header from the review.
- **numb_stars**: an integer that can assume values 1-5, corresponds to the review rating. 
- **dist_1st_rev**: numeric, corresponds to the number of weeks a review was posted since the first review received by a seller.
- **trend**: numeric, corresponds to the number of weeks a review was posted since the first review **from this dataset**.
- **review_helpful**: an integer, corresponds to the number of helpful feedback received by a review
- **review_posted_date**: the date a review was posted.
- **is_review_fake_cycles**: computed by the author, this variable equals 1 if the customer reviewed more than 1 product that was soliciting fake reviews on the same ecosystem (Facebook or Rapidworkers), or, if they were flagged as suspicious by users in a seller forum and cycles of size 4 or 6 between reviewers and products were detected in this dataset.
- **is_review_fake_jaccard**: computed by the author, this variable equals 1 if the reviews from different users were practically identical to one another according to the Jaccard similarity index, using shingles of size 4.


# Regression script
A small script to estimate the regressions was also provided for replication purposes.

The script first filters positive reviews (4 and 5 stars) and then uses glm to estimate Logit models and group the results in a regression table.

## References
When using this dataset, please cite the corresponding article "Incentives to fake reviews in Online Platforms" by Gustavo Q. Saraiva
