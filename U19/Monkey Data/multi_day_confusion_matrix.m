function multi_day_confusion_matrix(official,varargin)
if nargin==2
    trials = official.trials(varargin{1});
    s1 = official.condition(varargin{1}) == 1;
    s2 = official.condition(varargin{1}) == 2;
    s3 = official.condition(varargin{1}) == 3;
    s4 = official.condition(varargin{1}) == 4;
    s5 = official.condition(varargin{1}) == 5;
    s6 = official.condition(varargin{1}) == 6;
    s7 = official.condition(varargin{1}) == 7;
    s8 = official.condition(varargin{1}) == 8;
else
    trials = official.trials;
    s1 = official.condition == 1;
    s2 = official.condition == 2;
    s3 = official.condition == 3;
    s4 = official.condition == 4;
    s5 = official.condition == 5;
    s6 = official.condition == 6;
    s7 = official.condition == 7;
    s8 = official.condition == 8;
end

s1_prob = [sum(trials(s1)==0) sum(trials(s1)==2) sum(trials(s1)==3) sum(trials(s1)==4)] /length(trials(s1));
s2_prob = [sum(trials(s2)==1) sum(trials(s2)==0) sum(trials(s2)==3) sum(trials(s2)==4)] /length(trials(s2));
s3_prob = [sum(trials(s3)==1) sum(trials(s3)==2) sum(trials(s3)==0) sum(trials(s3)==4)] /length(trials(s3));
s4_prob = [sum(trials(s4)==1) sum(trials(s4)==2) sum(trials(s4)==3) sum(trials(s4)==0)] /length(trials(s4));
s5_prob = [sum(trials(s5)==1) sum(trials(s5)==0) sum(trials(s5)==3) sum(trials(s5)==4)] /length(trials(s5));
s6_prob = [sum(trials(s6)==1) sum(trials(s6)==2) sum(trials(s6)==0) sum(trials(s6)==4)] /length(trials(s6));
s7_prob = [sum(trials(s7)==1) sum(trials(s7)==2) sum(trials(s7)==3) sum(trials(s7)==0)] /length(trials(s7));
s8_prob = [sum(trials(s8)==0) sum(trials(s8)==2) sum(trials(s8)==3) sum(trials(s8)==4)] /length(trials(s8));

c1_prob = [s1_prob;s2_prob;s3_prob;s4_prob];
c2_prob = [s5_prob;s6_prob;s7_prob;s8_prob];

figure
tiledlayout(1,2, 'TileSpacing', 'compact')
nexttile
%sgtitle(['Confusion Matrices (' num2str(length(official.eod)) '-session average)'])
imagesc(c1_prob,[0 1]);
axis square
hold on
plot([0.5,0.5,1.5,1.5,0.5],[1.5,0.5,0.5,1.5,1.5],'g','linewidth',10)
plot([1.5,1.5,2.5,2.5,1.5],[2.5,1.5,1.5,2.5,2.5],'g','linewidth',10)
plot([2.5,2.5,3.5,3.5,2.5],[3.5,2.5,2.5,3.5,3.5],'g','linewidth',10)
plot([3.5,3.5,4.5,4.5,3.5],[4.5,3.5,3.5,4.5,4.5],'g','linewidth',10)
hold off
colormap(hot)
% c = colorbar;
% c.Label.String = 'proportion of choices';
xlabel('Ctx 1','FontSize',30,'FontWeight','bold')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({'A', 'B', 'C', 'D'})
yticks(1:4)
ax = gca;
ax.FontSize = 35;

nexttile
imagesc(c2_prob,[0 1]);
axis square
hold on
plot([1.5,1.5,2.5,2.5,1.5],[1.5,0.5,0.5,1.5,1.5],'g','linewidth',10)
plot([2.5,2.5,3.5,3.5,2.5],[2.5,1.5,1.5,2.5,2.5],'g','linewidth',10)
plot([3.5,3.5,4.5,4.5,3.5],[3.5,2.5,2.5,3.5,3.5],'g','linewidth',10)
plot([0.5,0.5,1.5,1.5,0.5],[4.5,3.5,3.5,4.5,4.5],'g','linewidth',10)
hold off
colormap(hot)
xlabel('Ctx 2','FontSize',30,'FontWeight','bold')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({})
yticks(1:4)
ax = gca;
ax.FontSize = 35;

c = colorbar('FontSize',22);
c.Label.String = 'proportion of choices';

end