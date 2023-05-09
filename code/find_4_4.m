% Finding New formula of determinant of 4*4 matrix
% Taehyeong Kim 2023-02-27
% th_kim@pusan.ac.kr
clc;
while 1
    clear;
    tic;
    % Set iteration number
    n = 70000;
    
    % Set size of matrix
    m = 4;
    
    % Initialize Dictionasy
    M = zeros(n,16^4);
    % Using multi-processing toolbox
    parfor p = 1:n
        A = 2*(rand(m)-0.5); % Generate a random matrix with values between -1 and 1
        N0 = A;
        N1 = [A(1,1)-A(2,1) A(1,2)-A(2,2) A(1,3)-A(2,3) A(1,4)-A(2,4)
              A(1,1)-A(3,1) A(1,2)-A(3,2) A(1,3)-A(3,3) A(1,4)-A(3,4)
              A(1,1)-A(4,1) A(1,2)-A(4,2) A(1,3)-A(4,3) A(1,4)-A(4,4)
              A(2,1)-A(3,1) A(2,2)-A(3,2) A(2,3)-A(3,3) A(2,4)-A(3,4)
              A(2,1)-A(4,1) A(2,2)-A(4,2) A(2,3)-A(4,3) A(2,4)-A(4,4)
              A(3,1)-A(4,1) A(3,2)-A(4,2) A(3,3)-A(4,3) A(3,4)-A(4,4)];
        N2 = [A(1,1)+A(2,1) A(1,2)+A(2,2) A(1,3)+A(2,3) A(1,4)+A(2,4)
              A(1,1)+A(3,1) A(1,2)+A(3,2) A(1,3)+A(3,3) A(1,4)+A(3,4)
              A(1,1)+A(4,1) A(1,2)+A(4,2) A(1,3)+A(4,3) A(1,4)+A(4,4)
              A(2,1)+A(3,1) A(2,2)+A(3,2) A(2,3)+A(3,3) A(2,4)+A(3,4)
              A(2,1)+A(4,1) A(2,2)+A(4,2) A(2,3)+A(4,3) A(2,4)+A(4,4)
              A(3,1)+A(4,1) A(3,2)+A(4,2) A(3,3)+A(4,3) A(3,4)+A(4,4)];
        N = [N0; N1; N2];
        y(p) = det(A);
        it = 1;
        v = zeros(1, 16^4);
    %   Create row of dictionary by random matrix A.
        for i = 1:16
            for j = 1:16
                for k = 1:16
                    for l = 1:16
                        tmp = N(i,1)*N(j,2)*N(k,3)*N(l,4);
                        v(it) = tmp;
                        it = it + 1;
                    end
                end
            end
        end
        M(p,:) = v;
    end
    toc;
    
    % LASSO
    lambda = 1e-4;
    B = lasso(M,y, 'Lambda', lambda, 'Intercept', false, 'Standardize', false);
    
    % Check the number of significant values greater than tolerance
    I=find(abs(B)>0.01);
    toc;
    % If the number of significant values is less than 20, 
    % the while loop is terminated.
    if length(B(I)) <= 20
        break
    end
end

Cand = ["A(1,1)" "A(1,2)" "A(1,3)" "A(1,4)"
        "A(2,1)" "A(2,2)" "A(2,3)" "A(2,4)"
        "A(3,1)" "A(3,2)" "A(3,3)" "A(3,4)"
        "A(4,1)" "A(4,2)" "A(4,3)" "A(4,4)"
        "(A(1,1)-A(2,1))" "(A(1,2)-A(2,2))" "(A(1,3)-A(2,3))" "(A(1,4)-A(2,4))"
        "(A(1,1)-A(3,1))" "(A(1,2)-A(3,2))" "(A(1,3)-A(3,3))" "(A(1,4)-A(3,4))"
        "(A(1,1)-A(4,1))" "(A(1,2)-A(4,2))" "(A(1,3)-A(4,3))" "(A(1,4)-A(4,4))"
        "(A(2,1)-A(3,1))" "(A(2,2)-A(3,2))" "(A(2,3)-A(3,3))" "(A(2,4)-A(3,4))"
        "(A(2,1)-A(4,1))" "(A(2,2)-A(4,2))" "(A(2,3)-A(4,3))" "(A(2,4)-A(4,4))"
        "(A(3,1)-A(4,1))" "(A(3,2)-A(4,2))" "(A(3,3)-A(4,3))" "(A(3,4)-A(4,4))"
        "(A(1,1)+A(2,1))" "(A(1,2)+A(2,2))" "(A(1,3)+A(2,3))" "(A(1,4)+A(2,4))"
        "(A(1,1)+A(3,1))" "(A(1,2)+A(3,2))" "(A(1,3)+A(3,3))" "(A(1,4)+A(3,4))"
        "(A(1,1)+A(4,1))" "(A(1,2)+A(4,2))" "(A(1,3)+A(4,3))" "(A(1,4)+A(4,4))"
        "(A(2,1)+A(3,1))" "(A(2,2)+A(3,2))" "(A(2,3)+A(3,3))" "(A(2,4)+A(3,4))"
        "(A(2,1)+A(4,1))" "(A(2,2)+A(4,2))" "(A(2,3)+A(4,3))" "(A(2,4)+A(4,4))"
        "(A(3,1)+A(4,1))" "(A(3,2)+A(4,2))" "(A(3,3)+A(4,3))" "(A(3,4)+A(4,4))"];
it = 1;
cnt = 1;
for i = 1:16
    for j = 1:16
        for k = 1:16
            for l = 1:16
                if it == I(cnt)
                    if B(it) > 0
                        disp(strcat('+',num2str(round(B(it)*2)/2), Cand(i,1), Cand(j,2), Cand(k,2), Cand(l,2)));
                    else
                        disp(strcat(num2str(round(B(it)*2)/2), Cand(i,1), Cand(j,2), Cand(k,2), Cand(l,2)));
                    end
                end
                cnt = cnt + 1;
                if cnt > length(I)
                    break
                end
                it = it + 1;
            end
            if cnt > length(I)
                break
            end
        end
        if cnt > length(I)
            break
        end
    end
    if cnt > length(I)
        break
    end
end
