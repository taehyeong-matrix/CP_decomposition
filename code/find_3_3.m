% Finding New formula of determinant of 3*3 matrix
% Taehyeong Kim 2023-02-27
% th_kim@pusan.ac.kr
clc;
tic;
while 1
    clear;
    % Set iteration number
    n = 1000;
    
    % Set size of matrix
    m = 3;
    
    
    M = zeros(n,9^3);
    % Using multi-processing toolbox
    parfor p = 1:n
        A = 2*(rand(m)-0.5); % Generate a random matrix with values between -1 and 1
        N0 = A;
        N1 = [A(1,1)-A(2,1) A(1,2)-A(2,2) A(1,3)-A(2,3)
              A(1,1)-A(3,1) A(1,2)-A(3,2) A(1,3)-A(3,3)
              A(2,1)-A(3,1) A(2,2)-A(3,2) A(2,3)-A(3,3)];
        N2 = [A(1,1)+A(2,1) A(1,2)+A(2,2) A(1,3)+A(2,3)
              A(1,1)+A(3,1) A(1,2)+A(3,2) A(1,3)+A(3,3)
              A(2,1)+A(3,1) A(2,2)+A(3,2) A(2,3)+A(3,3)];
        N = [N0;N1;N2];
        y(p) = det(A);
        it = 1;
        %   Create row of dictionary by random matrix A.
        v = zeros(1, 9^3);
        for i = 1:9 % 9
            for j = 1:9 % 9
                for k = 1:9 % 9
                    tmp = N(i,1)*N(j,2)*N(k,3);
                    v(it) = tmp;
                    it = it + 1;
                end
            end
        end
        M(p,:) = v;
    end
    
    % LASSO
    lambda = 0.001;
    B = lasso(M,y, 'Lambda', lambda, 'Intercept', false, 'Standardize', false);
    % Check the number of significant values greater than tolerance
    I=find(abs(B)>0.01);
    % toc;
    % If the number of significant values is less than 20, 
    % the while loop is terminated.
    if length(B(I)) < 6
        break
    end
end
toc;
Cand = ["A(1,1)" "A(1,2)" "A(1,3)"
        "A(2,1)" "A(2,2)" "A(2,3)"
        "A(3,1)" "A(3,2)" "A(3,3)"
        "(A(1,1)-A(2,1))" "(A(1,2)-A(2,2))" "(A(1,3)-A(2,3))"
        "(A(1,1)-A(3,1))" "(A(1,2)-A(3,2))" "(A(1,3)-A(3,3))"
        "(A(2,1)-A(3,1))" "(A(2,2)-A(3,2))" "(A(2,3)-A(3,3))"
        "(A(1,1)+A(2,1))" "(A(1,2)+A(2,2))" "(A(1,3)+A(2,3))"
        "(A(1,1)+A(3,1))" "(A(1,2)+A(3,2))" "(A(1,3)+A(3,3))"
        "(A(2,1)+A(3,1))" "(A(2,2)+A(3,2))" "(A(2,3)+A(3,3))"];
it = 1;
for i = 1:9
    for j = 1:9
        for k = 1:9
            if it == I(1) || it == I(2) || it == I(3) || it == I(4) || it == I(5)
                if B(it) > 0
                    disp(strcat('+',num2str(round(B(it)*2)/2), Cand(i,1), Cand(j,2), Cand(k,2)));
                else
                    disp(strcat(num2str(round(B(it)*2)/2), Cand(i,1), Cand(j,2), Cand(k,2)));
                end
            end
            it = it + 1;
        end
    end
end
toc;