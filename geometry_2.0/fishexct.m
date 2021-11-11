function P=fishexct(Tbl)
% Computes Fisher's exact probability for observing, in a 2x2 contingency
% table, deviations of cell values from their expectations as great or
% greater than the deviations observed--on the null hypothesis that the
% cell values can be predicted from the row and column totals, that is,
% that there is no contingency. Syntax is P=fishexct(Tbl). Tbl is a 2x2
% contingency table. The p value returned is for the 2-tailed test, the
% probability of a deviation that extreme or more, regardless of direction.
% 1-tailed value is half the value returned



SmlstCel=find(Tbl(:)==min(Tbl(:))); % Finds the number of the cell with the lowest entry.
% Cell numbering is first down the columns. Matrices (tables) that are still more
% improbable are created by making this number smaller while making the
% adjustments in the other 3 cells required to keep the
% row and column totals unchanged. These adjustments consist of adding the
% 1 removed from the smallest cell to the cell in its row, subtracting 1
% from the cell diagonal to it and adding 1 to the cell in the same row as
% that diagonal cell

if (SmlstCel==1)|(SmlstCel==4)
    Diag=1; % if Diag=1, cell is on the principal diagonal;
else
    Diag=0;  % if 0, it's on the other diagonal
end

SmlstEnt=Tbl(SmlstCel); % The value in the smallest cell

if SmlstEnt>5
    disp('Smallest entry greater than 5. Suggest use of chi2p')
    disp('Factorials in Fisher exact get unmanageable when entries > 21')
end

Fop(:,:,1)=[-1 1;1 -1];Fop(:,:,2)=fliplr(Fop(:,:,1)); % Create the operator
% matrices that will adjust cell values incrementally. The operator at
% Level 1 is used when the cell with the smallest entry is on the principal
% diagonal; the operator at Level 2 is used when it is on the other
% diagonal

Tabl(:,:,1)=Tbl; % Makes the input contingency table the bottom level in
% what will become a stack of tables, with each higher table in the stack
% having a more improbable distribution

if SmlstEnt>0 % if there are more improbable tables than the input table
    
    for i=2:SmlstEnt+1 % Iterate creation of more improbably tables until
    % value in smallest cell is 0. Number of interations is equal to the
    % smallest entry
    
        if Diag==1 % smallest entry is on the principal diagonal
            
            Tabl(:,:,i)=Tabl(:,:,i-1)-Fop(:,:,2);
            
        else
            
            Tabl(:,:,i)=Tabl(:,:,i-1)-Fop(:,:,1);
            
        end % of closest if
        
    end % of for loop
    
end % of remotest if
        
T=sum(Tbl(:)); %Total number of observations

Rw=sum(Tabl,1);Cl=sum(Tabl,2); % Row and column totals

for i=1:size(Tabl,3) % for each level of Tabl
    
    Nm=factorial(Rw(1,1,i))*factorial(Rw(1,2,i))*factorial(Cl(1,1,i))*factorial(Cl(2,1,i));
    Dnm=factorial(T)*factorial(Tabl(1,1,i))*factorial(Tabl(2,1,i))*factorial(Tabl(1,2,i))*factorial(Tabl(2,2,i));
    p(i)=Nm/Dnm;
    
end

P=2*sum(p); % 2-tailed Fisher exact probability,
% that is, the chance of getting a deviation that extreme or more in either
% direction
    