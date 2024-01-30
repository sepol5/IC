function ex()
%  preparação de dados de aprendizagem
Num_Inputs=10;% nº dos inputs
P=zeros(Num_Inputs,4);% input matrix
T=zeros(4,1);
for h=1:4 % 4
    switch h
       case 1
          Img = imread('0_triangle.png');
          y=imbinarize(Img);
          Target=[1;0;0;0];
       case 2 
          Img = imread('0_star.png');
          y=imbinarize(Img);
          Target=[0;1;0;0];
       case 3
           Img = imread('0_square.png');
           y=imbinarize(Img);
           Target=[0;0;1;0];
       case 4
           Img = imread('0_circle.png');
           y=imbinarize(Img);
           Target=[0;0;0;1];
       
    end %fim switch 
    
    T(:,h)=Target ; % valores da matriz T
[Num_Row,Num_column] = size(y) ;% determinar tamanho da imagem

           for i=1:Num_Inputs
                     for j=(((Num_Row/Num_Inputs)*(i-1))+1) : ((Num_Row/Num_Inputs)*(i))
                          for k=1 : Num_column
                             if y(j,k)==0
                             P(i,h)=P(i,h)+k ;
                             end
                           end
                     end
           end
end % fim ciclo for
%fim dos dados de aprendizagem
%simulaçao dos dados de aprendizagem
S=zeros(Num_Inputs,4);% matriz de simulaçao
for h=1:4 % 4 loops para 4 imagens
    switch h
       case 1
          Img = imread('0_triangle.png');
           y=imbinarize(Img);
          
       case 2
           Img = imread('0_star.png');
            y=imbinarize(Img);
           
        case 3
           Img = imread('0_square.png');
            y=imbinarize(Img);
        
        case 4
           Img = imread('0_circle.png');
            y=imbinarize(Img);
           
    end %fim switch 
[Num_Row,Num_column] = size(y) ;
% inicio for  matriz input
           for i=1:Num_Inputs
                     for j=(((Num_Row/Num_Inputs)*(i-1))+1) : ((Num_Row/Num_Inputs)*(i))
                          for k=1 : Num_column
                             if y(j,k)==0
                             S(i,h)=S(i,h)+k ;
                             end
                           end
                     end
           end
end % fim loop for
%fim da simulaçao de dados
% normalizaçao
A=[P,S] ;
maxi=max(max(A));
mini=min(min(A));
[a,b]=size(A);
for i=1:a
    for j=1:b
        AN(i,j)=2*(A(i,j)/(maxi-mini))-1;
    end
end
P=AN(:,1:4);
S=AN(:,5:7);
%fim da normalizaçao
% criaçao de redes neuronais
Num_Neuron_Hidden=20 ;%número de neurônios na camada oculta
net.trainFcn = 'trainlm'
net.layers{1}.transferFcn =  'tansig'

 net.divideFcn = 'dividerand'
 net.divideParam.trainRatio = 0.70
 net.divideParam.valRatio = 0.15
 net.divideParam.testRatio = 0.15
 
 net = feedforwardnet;
%net = newff(P,T,Num_Neuron_Hidden,{},'traingd');%camadas escondidas Num_Neuron_Hidden=10 
%net=init(net); % Reinicialização de pesos e bias
%net.trainparam.epochs=250;% número máximo iteração
%net.trainparam.goal=0.0001; % erro
%net=train(net,P,T); %funçao treino
% fim de aprendizagem

[net,tr] = train(net, Num_Inputs, Target);
view(net);
disp(tr)

%view(net);
%  Simulaçao
out = sim(net, Num_Inputs);
%y = sim(net,S);
% fim simulaçao

plotconfusion(Target, out)
plotperf(tr)


r=0;
for i=1:size(out,2)               % Para cada classificacao  
  [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
  [c d] = max(Target(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
  if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
      r = r+1;
  end
end

accuracy = r/size(out,2)*100;
fprintf('Precisao total %f\n', accuracy)
%k=4;

% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
TInput = Num_Inputs(:, tr.testInd);
TTargets = Target(:, tr.testInd);

out = sim(net, TInput);


%Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
r=0;
for i=1:size(tr.testInd,2)               % Para cada classificacao  
  [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
  [c d] = max(TTargets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
  if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
      r = r+1;
  end
end
accuracy = r/size(tr.testInd,2)*100;
fprintf('Precisao teste %f\n', accuracy)
end