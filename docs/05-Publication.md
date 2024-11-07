# Publication

Projects generate a variety of types of publications. These may include

- Pre-analysis plans,
- Final technical reports, 
- Public versions of GitHub repositories, 
- Public versions of data, and
- Peer-reviewed academic journal articles. 

## Authorship in Pre-Analysis Plans

For pre-analysis plans, we ascribe to the three standards of _substantial contribution_, _approval_, and _accountability_ that _Nature_ lays out [here](https://www.nature.com/nature/editorial-policies/authorship).


## Authorship in Academic Articles

For academic papers, we ascribe to the three standards of _substantial contribution_, _approval_, and _accountability_ that _Nature_ lays out [here](https://www.nature.com/nature/editorial-policies/authorship).

## Publishing Data

We strive to post useful replication data to the extent possible in each project. Some examples of our work doing so include projects on the 911 [nurse triage line](https://github.com/thelabdc/FEMS-911NurseTriageLine-Public) and 457b [enrollment](https://github.com/thelabdc/DCHR-457b-Public).

The federal OPRE has some helpful advice for doing so [here](https://www.acf.hhs.gov/opre/report/guide-publishing-research-data-secondary-analysis).

## Presenting Results

### Estimates and uncertainties

When we want to communicate group estimates along with treatment effects, we display them with barplots or scatterplots. Where we are interested in inference about a treatment effect, we display the control group and treatment group means, with the uncertainty around the treatment group mean representing the uncertainty around the treatment effect. For example, 

<img src="05-Publication_files/figure-html/display_te_uncertainty-1.png" width="672" />

When we want to communicate treatment effects without both group means being explicit, we do so with a coefficient plot. For example, with the intercept (control group mean),

<img src="05-Publication_files/figure-html/display_coefplot-1.png" width="672" />

or without the intercept,


<img src="05-Publication_files/figure-html/display_coefplot_noint-1.png" width="672" />

