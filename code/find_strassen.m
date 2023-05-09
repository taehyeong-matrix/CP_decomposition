% Finding Strassen matrix multiplication
% Taehyeong Kim 2023-05-09
% th_kim@pusan.ac.kr
clc; clear;

tic;
while 1
    clear; 
    % Set iteration number
    n = 100;
    
    % Set size of matrix
    m = 2;
    
    K = 7;
    M = zeros(n,K*K);
    % Using multi-processing toolbox
    parfor p = 1:n
        A = rand(2,2)*2-1;
        B = rand(2,2)*2-1; % Generate a random matrix with values between -1 and 1
        N = [A(1,1) B(1,1)
             A(2,2) B(2,2)
             A(1,1) + A(2,2) B(1,1) + B(2,2)
             A(2,1) + A(2,2) B(2,1) + B(2,2)
             A(1,1) + A(1,2) B(1,1) + B(1,2)
             A(1,1) - A(2,1) B(1,1) - B(2,1)
             A(1,2) - A(2,2) B(1,2) - B(2,2)]

        AB = A*B;
        y1 = reshape(AB,1,4);
        y(p,:) = y1;
        it = 1;
        %   Create row of dictionary by random matrix A.
        v = zeros(1, K*K);
        for i = 1:K % 9
            for j = 1:K % 9
                tmp = N(i,1)*N(j,2);
                v(it) = tmp;
                it = it + 1;
            end
        end
        M(p,:) = v;
    end

    % Group sparse optimization
    lambda = 0.01;
    B = M\y;  % initial guess: Least-squares
    
    % lambda is our sparsification knob.
    for k=1:10
        smallinds = (abs(B)<lambda);   
        B(smallinds)=0;                
        for ind = 1:4                   % state dimension is 4
            biginds = ~smallinds(:,ind);
            % Regress dynamics onto remaining terms to find sparse B
            B(biginds,ind) = M(:,biginds)\y(:,ind); 
        end
    end
    
    % Check the number of significant values greater than tolerance
    I=find(sum(abs(B),2)>0);
    disp(length(B(I,:)))
    % toc;
%     If the number of significant values is less than 8, 
%     the while loop is terminated.
    w = warning('query','last');
    id = w.identifier;
    warning('off',id)
    if length(B(I,:)) <= 7
        break
    end
end

norm(M*B - y)


%%
clc;
Cand = [ "A(1,1)" "B(1,1)"
         "A(2,2)" "B(2,2)"
         "(A(1,1) + A(2,2))" "(B(1,1) + B(2,2))"
         "(A(2,1) + A(2,2))" "(B(2,1) + B(2,2))"
         "(A(1,1) + A(1,2))" "(B(1,1) + B(1,2))"
         "(A(1,1) - A(2,1))" "(B(1,1) - B(2,1))"
         "(A(1,2) - A(2,2))" "(B(1,2) - B(2,2))"];
result = ["C(1,1) = "
          "C(2,1) = "
          "C(1,2) = "
          "C(2,2) = "];
it = 1;
for i = 1:K
    for j = 1:K
        Cand2(it,1) = Cand(i,1) + Cand(j,2);
        it = it + 1;
    end
end


for i = 1:length(I)
    disp(strcat('m',num2str(i),'=',Cand2(I(i))))
end

for i = 1:4
    disp(" ")
    disp(result(i))
    for j = 1: K*K
        if B(j,i) > 0
            disp(strcat("+", num2str(B(j,i)) ,Cand2(j)))
        elseif B(j,i) < 0
            disp(strcat(num2str(B(j,i)) ,Cand2(j)))
        end
    end
end
toc