function rede()
%  prepara��o de dados de aprendizagem
Num_Inputs=10 ;% n� dos inputs
P=zeros(Num_Inputs,4);% input matriz
T=zeros(4,1);
for h=1:4 % 4
    switch h
       case 1
          Img = imread('0_triangle.png');
          Target=[1;-1;-1;-1];
       case 2 
          Img = imread('0_star.png');
          Target=[-1;1;-1;-1];
       case 3
           Img = imread('0_square.png');
           Target=[-1;-1;1;-1];
       case 4
           Img = imread('0_circle.png');
           Target=[-1;-1;-1;1];
       
    end %fim switch 
    
    T(:,h)=Target ; % valores da matriz T
[Num_Row,Num_column] = size(Img) ;% determinar tamanho da imagem
 % 
           for i=1:Num_Inputs
                     for j=(((Num_Row/Num_Inputs)*(i-1))+1) : ((Num_Row/Num_Inputs)*(i))
                          for k=1 : Num_column
                             if Img(j,k)==0
                             P(i,h)=P(i,h)+k ;
                             end
                           end
                     end
           end
end % fim ciclo for
%fim dos dados de aprendizagem
%simula�ao dos dados de aprendizagem
S=zeros(Num_Inputs,4);% matriz de simula�ao
for h=1:4 %  4 loops para 4 imagens
    switch h
       case 1
          Img = imread('0_triangle.png');
          
       case 2
           Img = imread('0_star.png');
           
        case 3
           Img = imread('0_square.png');
        
        case 4
           Img = imread('0_circle.png');
           
    end %fim switch 
[Num_Row,Num_column] = size(Img) ;
% inicio for  matriz input
           for i=1:Num_Inputs
                     for j=(((Num_Row/Num_Inputs)*(i-1))+1) : ((Num_Row/Num_Inputs)*(i))
                          for k=1 : Num_column
                             if Img(j,k)==0
                             S(i,h)=S(i,h)+k ;
                             end
                           end
                     end
           end
end %  fim loop for
%fim da simula�ao de dados
% normaliza�ao
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
%fim da normaliza�ao
% cria�ao de redes neuronais
Num_Neuron_Hidden=20 ;%n�mero de neur�nios na camada oculta
net = newff(P,T,Num_Neuron_Hidden,{},'traingd');%camadas escondidas Num_Neuron_Hidden=10 
net=init(net); % Reinicializa��o de pesos e bias
net.trainparam.epochs=250;% n�mero m�ximo itera��o
net.trainparam.goal=0.0001; % erro
net=train(net,P,T); %fun�ao treino
% fim de aprendizagem
 
view(net);
%  Simula�ao 
y = sim(net,S);
% fim simula�ao
k=4;
end