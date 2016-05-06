function [F,rank] = fast_non_dominated_sort(p)
%This function gets a set of points and caclulate the level sets, and the
%rank of each point. 

%S is the set of points - it has S(i).Sp and S(i).np for each point
%F is the levels - F(i).point are the index of the points in level i
[n,m] = size(p); % p is n*m
S.Sp= [];
S.np = 0;
F.point = [];
rank = zeros(1,n);

for i = 1:n
    S(i).np = 0;
    S(i).Sp = [];
    for j = 1:n
        if(i ~= j)            
            flag = 0;
            if (p(i,1) <= p(j,1))&&(p(i,2) <= p(j,2))
                if ((p(i,1) < p(j,1))&&(p(i,2) <= p(j,2)))||((p(i,1) <= p(j,1))&&(p(i,2) < p(j,2)))
                    flag = 1;
                end
            end
            if (flag)
                S(i).Sp = [S(i).Sp,j];
            elseif (p(i,1) >= p(j,1))&&(p(i,2) >= p(j,2))
                    if ((p(i,1) > p(j,1))&&(p(i,2) >= p(j,2)))||((p(i,1) >= p(j,1))&&(p(i,2) > p(j,2)))
                        S(i).np = S(i).np + 1;
                    end
            end                
        end
    end
    if (S(i).np == 0)
        rank(1,i) = 1;
        F(1).point = [F(1).point,i];
    end 
end

i = 1;
while size(F(i).point,2) ~= 0
    Q = [];
    temp_p_size = size(F(i).point,2);
    for temp_p = 1:temp_p_size
       temp_q_size = size(S(F(i).point(temp_p)).Sp,2);
       for temp_q = 1:temp_q_size
           S(S(F(i).point(temp_p)).Sp(temp_q)).np = S(S(F(i).point(temp_p)).Sp(temp_q)).np - 1;
           if (S(S(F(i).point(temp_p)).Sp(temp_q)).np == 0)
               rank(S(F(i).point(temp_p)).Sp(temp_q)) = i+1;
               Q = [Q,S(F(i).point(temp_p)).Sp(temp_q)];
           end
       end
    end
    i = i + 1;
    F(i).point = Q;
end
