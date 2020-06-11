clc
clear all


% inData = 'abcdaabbccaaabbbcfaaaabbbccdffeeeaaabbbcccdefabcde';  %输入文本
inData = 'i am a student i study iot subject in guangzhou university i like the subject and will work hard and do my best to achieve a high score in final examination'
% size(inData)
% double(inData)
% % find(inData==' ')



%%%字符频率统计
uniqueCharacter=unique(inData);%计算有多少个不重复的字符串
for i=1:length(uniqueCharacter)
uniqueCharacter_num(i)=length(strfind(inData,uniqueCharacter(i))); %统计字符的数目
uniqueCharacter_p(i) = uniqueCharacter_num(i)/length(inData);%不同字符出现的概率
end

%%创建哈夫曼树
%对字符出现的概率按照从低到高排序
p = uniqueCharacter_p
[a,b]=sort(p); %对p概率矩阵进行排列
m(1,:) = b;
for i = 1:length(a)
    c(i) = uniqueCharacter(b(i));%更新字符队列的排序
end
q = sort(p); %更新概率顺序
n = length(uniqueCharacter_p);
for i = 2:n
    matrix(i-1,2,:) = c(1);   %在matrix中记录左孩子
    matrix(i-1,3,:) = c(2);   %在matrux中记录右孩子
    matrix(i-1,1,:) = double(i-1);                %在matrix中记录根节点
    c(2) = double(i-1);%此处补充数值1，目的是为了以后排序该位置总排在最后，不被处理
    q(2) = q(1) + q(2);     %更新根节点数值
    q(1) = 1;
    %对新的概率组合进行排序   
    [a,b]=sort(q);
    [a1,b1] = sort(b); 
    m(i,:)=b1; %%进行两次sort排记录记录概率对应的位置
    temp_c = c;  %引入中间变量
    temp_q = q;
    for i = 1:length(a1)
         c(i) = temp_c(b(i));%更新字符队列的排序
         q(i) = temp_q(b(i));
         
    end
end



%读哈夫曼编码
disp('哈夫曼编码表：')
code = uniqueCharacter';
for i = 1:n
    [temp_code,n] = Coding(matrix,uniqueCharacter(i));
    code(i,3:n+2) = temp_code
    len(i) = n;
end

disp('编码压缩效率:')
e = (sum(uniqueCharacter_num)*8)/sum(len.*uniqueCharacter_num)

function [code,n] = Coding(matrix,character)
    [a,b] = size(matrix);
    for i = 1:a
        [row,col] = find(matrix(:,2:3)==character);
        character = matrix(row,1);
        if col == 1
            temp_code(i) = '0';
        else
            temp_code(i) = '1';
        end
        code(i) = temp_code(i);
        if row == a
            break
        end
    end
    %此刻需要将编码结果倒转
    temp_code = code;
    n = length(code);
    for i = 1:n
        code(i) = temp_code(length(code)-i+1) ;
    end
end





