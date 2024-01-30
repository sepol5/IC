function percept3a( )
%Funcao percepcao3a: cria, treina e testa um perceptrao
%usando as funcoes da NNTool

% limpar
clear all;
close all;

% inicializar entrada

Num_Inputs=4 
P=zeros(Num_Inputs,4);
 Img = imread('0_triangle.png');
 y=imbinarize(Img);

%informacao sobre operador logico 
fprintf('Introduza operador logico desejado:\n');
fprintf('1 - triangle\n');
fprintf('2 - star\n');
fprintf('3 - square\n');
fprintf('4 - circle\n');
tmp =  input('                        operador? (default 1) = ');

% inicializar targets
if isempty(tmp)
    Target=[1;-1;-1;-1];
    op='triangle';
else
    switch tmp
        case 1
            Img = imread('0_triangle.png');
            y=imbinarize(Img);
            Target=[1;-1;-1;-1];
            op='triangle';
        case 2
            Img = imread('0_star.png');
            y=imbinarize(Img);
            Target=[-1;1;-1;-1];
            op='star';
        case 3
            Img = imread('0_square.png');
            y=imbinarize(Img);
             Target=[-1;-1;1;-1]
            op='square';
        case 4
            Img = imread('0_circle.png');
            y=imbinarize(Img);
            Target=[-1;-1;-1;1];
            op='circle';
        otherwise
           Img = imread('0_triangle.png');
            y=imbinarize(Img);
            Target=[1;-1;-1;-1];
            op='triangle';
    end
end

T(:,h)=Target ;
% COMPLETAR: criar um perceptrao chamado net

net = perceptron;
%XORNet= feedforwardnet;
%rede2 = feedforwardnet([5 5


% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
net.layers{1}.transferFcn='tansig';
%net.layers{2}.transferFcn='purelin';

% COMPLETAR: Numero de epocas de treino: 100
net.trainParam.epochs = 100;
%XORNet.trainFcn = 1000;

% FUNCAO DE TREINO 
%net.trainFcn='traingdx';

% TODOS OS EXEMPLOS DE INPUT SAO USADOS NO TREINO
%net.divideFcn = ''; 

% COMPLETAR: treinar a rede
net = train(net, p, t);
%XORNet

% visualizar a rede
view(net)

% COMPLETAR: simular a rede e guardar o resultado na variavel y
out = sim(net, p);

% Mostrar resultado
%p = (p >= 0.5);
fprintf('Saida do perceptrao para %s:', op);
disp(p);
fprintf('Saida desejada para %s:', op);
disp(t);



%Plot 
w = net.iw{1,1};
b = net.b{1};
plotpv(p, t)
plotpc(w, b)

end