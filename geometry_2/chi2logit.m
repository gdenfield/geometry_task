function [Lgt,Level,NV]=chi2logit(Cum,R)
% Version 2 (uses Fisher exact when chi2 not valid). Returns (Lgt) the log of the odds against the null hypothesis that
% the  percentages of 1's before and after the putative change points
% do not differ. Also (optionally) the point (Level) beyond which the
% Chi square test is valid (because no expectation < 5)
% and (NV) the rows for which the chi square test cannot
% validly be performed (because at least one cell has an expectation
% less than 5). Syntax is [Lgt Level NV]=chi2logit(Cum,R).
% Cum is the running sum of the number of 1's. R is the vector
% of putative change points. Lgt is the logit vector, giving for each
% trial the log of the odds against the null (no change) hypothesis as of
% that trial. This version was modified in Oct or Nov 2003 so that it does the
% Fisher exact test on those tables where the chi square is not valid.

N(1,1,:)=(1:length(Cum))'; % Creates a 3 dimensional array with the levels
% (3rd dimension nummbered in ascending sequence). The first two dimensions
% are dummy dimensions to make this array the same dimensionality as the
% ones it will be combined with. Conceptually, this is just a vector.

% Column totals. These are the numbers of observations (sums of 0's & 1's)
% before (1st column) and after (second column) the CP. Note that these are
% three dimensional arrays, but the first (row) dimension is a singleton,
% i.e., a dummy dimension, only 1 cell deep.

Level1=min(find(Cum>6)); % Finds the row (level of stacked 2x2 tables)
% below which even the Fisher exact test should not be applied, because it
% cannot yield a p value lower than .1 with fewer than 7 observations, and,
% moreover, for fewer than 4 observations, fishexct.m returns p values
% greater than 1.

C(1,1,:)=R; % First column totals = numbers of observations up to and
% including putative CP

C(1,2,:)=N(1,1,:)-C(1,1,:); % Second column totals = # observations after CP

Rw(1,1,:)=Cum; % First row totals = total numbers of 1's

Rw(2,1,:)=N(1,1,:)-Rw(1,1,:); % Second row totals = total numbers of 0's

Smallest=min(Rw).*min(C)./N; % The smallest expectation is the
% smallest row total times the smallest column total, divided by N

NV=find(Smallest<5); % Critical value for cell expectations is 5. NV is the
% vector of rows whose contingency tables have a cell with less than the
% critical value

Level=max(NV); % The highest level at which the  smallest expectation is less than 5.
 % Chi square is not valid when smallest expectation less than 5.
 

 % Constructing the three dimensional array of cell totals (rows by columns by levels). Each level
% is a 2x2 table. The rows of the table are the
% mutually exclusive and exhaustive outcomes (# of 1's in first row, # of
% 0"s in second row). The columns of a level are before and after the
% putative change point. Thus, at a given level, L, Cell(1,1,L) gives the
% number of rewards on the given hole up to the putative change point;
% Cell (2,1,L) gives the number of rewards on the other hole up to the
% putative change point; Cell(2,1,L) gives the number of rewards on the
% given hole after the putative change point; and Cell(2,2,L) gives the
% nummber on the other hole after the putative change point. There are
% as many levels as there are rows in the Cum vector, because the chi square test is
% repeated for each successive entry.

T(1,1,:)=Cum(R); % first cell of chi square table (# 1's up to R)

 T(1,2,:)=Cum-Cum(R); % # 1's after R
 
 T(2,1,:)=C(1,1,:)-T(1,1,:); % Once the entries in the first row of the
 % 2x2 table have been filled in, the entries in the bottom row are
 % determined because the sum down the column must equal the column total.
 % Thus, the entry for the bottom row is the column total minus the entry
 % for the top row
 
 T(2,2,:)=C(1,2,:)-T(1,2,:); % # 0's after R
 
 Num=N(1,1,:).*(T(1,2,:).*T(2,1,:)-T(1,1,:).*T(2,2,:)).^2; % numerator of chi sq
 
 Denom=Rw(1,1,:).*Rw(2,1,:).*C(1,1,:).*C(1,2,:); % denominator
 
 ChiSq=squeeze(Num./Denom); % squeeze gets rid of dummy dimensions (those only 1 cell deep)
 
 ChiSq(1:Level1)=1; % Sets chisquare equal 1 for all those initial rows where it is not valid
 
for i=1:length(ChiSq)
    p(i)=chi2cdf(ChiSq(i),1); % This is p of ChiSq smaller than is observed. The improbability
    % of the null is 1-p
end

p=p';
 
 for rw=1:length(NV); p(NV(rw))=fishexct(T(:,:,NV(rw))); end % Uses Fisher's exact test to compute
 % p's for the cases where chi square is not valid
 
Lgt=log10(p./(1-p));

Lgt(1:Level1)=0; % Zeros logit values for the initial string of observations within which
% there are too few observations to do even Fisher's exact test
