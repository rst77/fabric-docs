# Rede Blockchain

Este tópico descreverá, **em nível conceitual**, como a Hyperledger Fabric 
permite que as organizações colaborem na formação de redes blockchain. Se você é 
um arquiteto, administrador ou desenvolvedor, pode usar este tópico para obter 
um entendimento sólido dos principais componentes da estrutura e dos processos 
em uma rede de blockchain Hyperledger Fabric. Este tópico usará uma atividade
prática de exemplo, que apresenta todos os principais componentes em uma 
rede blockchain.

Depois de ler este tópico e entender o conceito de políticas, você terá um sólido 
entendimento das decisões que as organizações precisam tomar para estabelecer as
políticas que controlam uma rede implantada na Hyperledger Fabric. Você também 
entenderá como as organizações gerenciam a evolução da rede usando políticas 
declarativas -- um recurso importante da Hyperledger Fabric. Em poucas palavras,
você entenderá os principais componentes técnicos do Hyperledger Fabric e as 
decisões que as organizações precisam tomar sobre eles.

## O que é uma rede blockchain?

Uma rede blockchain é uma infraestrutura técnica que fornece serviços de 
livro-razão e contrato inteligente (chaincode) para os aplicativos. Inicialmente, 
os contratos inteligentes são usados para gerar transações que são 
subsequentemente distribuídas para todos os nós da rede onde são gravados de 
maneira imutável em sua cópia do livro-razão. Os usuários dos aplicativos podem
ser usuários finais ou administradores da rede blockchain.

Na maioria dos casos, várias [organizações](../glossary.html#organizacao) se 
reúnem como um [consórcio](../glossary.html#Consorcio) para formar a rede e 
determinar suas permissões por meio de um conjunto de [políticas](../glossary.html#politica) 
que são acordadas pelo consórcio quando a rede é configurada. Além disso, as 
políticas de rede podem mudar com o tempo, dependendo do acordo das organizações 
no consórcio, como descobriremos quando discutirmos o conceito de *política de alteração*.

## Rede de exemplo

Antes de começarmos, vamos mostrar o que pretendemos fazer! Aqui está um diagrama 
representando o **estado final** da nossa rede de exemplo.

Não se preocupe, pois isso pode parecer complicado! À medida que discutimos este
tópico, construiremos a rede peça por peça, para que você veja como as 
organizações R1, R2, R3 e R4 contribuem com infraestrutura para ajudar a rede
a se formar. Essa infraestrutura implementa a rede blockchain e é governada por 
políticas acordadas pelas organizações que formam a rede -- por exemplo, quem 
pode adicionar novas organizações. Você descobrirá como os aplicativos consomem 
os serviços de livro-razão e contrato inteligente fornecidos pela rede blockchain.

![network.structure](./network.diagram.1.png)

*Quatro organizações, R1, R2, R3 e R4, decidiram em conjunto formalizar um 
contrato onde irão configurar e explorar uma rede Hyperledger Fabric. O R4 foi 
designado para ser o criador da rede -- ele tem a capacidade de configurar a 
versão inicial da rede. O R4 não tem intenção de realizar transações comerciais 
na rede. R1 e R2 precisam de uma comunicação privada dentro da rede geral, assim 
como R2 e R3. A organização R1 possui um aplicativo cliente que pode executar 
transações comerciais no canal C1. A organização R2 possui um aplicativo cliente 
que pode executar um trabalho semelhante nos canais C1 e C2. A organização R3 
tem um aplicativo cliente que pode fazer isso no canal C2. O nó P1 mantém 
uma cópia do livro-razão L1 associada a C1. O nó P2 mantém uma cópia do razão L1 
associada ao C1 e uma cópia do razão L2 associada ao C2. O nó P3 mantém uma 
cópia do razão L2 associada a C2. A rede é governada de acordo com as regras da
política especificada na configuração de rede NC4, a rede está sob o controle 
das organizações R1 e R4. O canal C1 é governado de acordo com as regras da 
política especificada na configuração de canal CC1; o canal está sob o controle
das organizações R1 e R2. O canal C2 é governado de acordo com as regras da 
política especificada na configuração do canal CC2; o canal está sob o controle 
das organizações R2 e R3. Há um serviço de ordem O4 que atua como um ponto de 
administração de rede para N e usa o canal do sistema. O serviço de ordem também 
suporta os canais de aplicativos C1 e C2, para fins de ordem de transações dos 
blocos para distribuição. Cada uma das quatro organizações possui uma Autoridade 
de Certificação preferida.*

## Criando uma Rede

Vamos começar do inicio, criando a base para a rede:

![network.creation](./network.diagram.2.png)

*A rede é formada quando um ordenador é iniciado. Em nossa rede de exemplo, N, o
serviço de ordens, é um único nó, O4, e é configurado de acordo com uma 
configuração de rede NC4, que concede direitos administrativos à organização R4. 
No nível da rede, a Autoridade de Certificação CA4 é usada para distribuir 
identidades aos administradores e nós de rede da organização R4.*

Podemos ver que a primeira coisa que define uma **rede, N,** é um 
**serviço de ordens, O4**. É útil pensar no serviço de ordens como o ponto 
inicial de administração da rede. Conforme combinado anteriormente, o O4 é 
inicialmente configurado e iniciado por um administrador na organização R4 e
hospedado no R4. A configuração NC4 contém as políticas que descrevem o conjunto
inicial de recursos administrativos para a rede. Inicialmente, isso é definido 
para conceder apenas direitos a R4 na rede. Isso vai mudar, como veremos mais 
adiante, mas por enquanto R4 é o único membro da rede.

### Autoridades de Certificação

Você também pode ver a autoridade de certificação CA4, usada para emitir 
certificados para administradores e para os nós da rede. O CA4 desempenha um 
papel fundamental em nossa rede porque distribui certificados X.509 que podem 
ser usados para identificar componentes como os pertencentes à organização R4. 
Os certificados emitidos pelas CAs também podem ser usados para assinar 
transações para indicar que uma organização endossa o resultado da transação 
-- uma condição prévia para que ela seja aceita no livro-razão. Vamos examinar 
esses dois aspectos de uma autoridade de certificação com mais detalhes.

Em primeiro lugar, diferentes componentes da rede blockchain usam certificados 
para se identificarem como pertencentes a uma organização específica. É por isso 
que geralmente há mais de uma CA suportando uma rede blockchain -- organizações 
diferentes costumam usar CAs diferentes. Nós vamos usar quatro CAs em nossa rede,
um para cada organização. De fato, as CAs são tão importantes que o Hyperledger 
Fabric fornece uma integrada (chamada *Fabric-CA*) para ajudá-lo a avançar, 
embora, na prática, as organizações escolham usar sua própria CA.

O mapeamento de certificados para organizações membros é realizado por meio de 
uma estrutura chamada [Serviço Provedor de Associação (MSP)](../glossary.html#Servico-Associacao). 
A configuração da rede NC4 usa um MSP nomeado para identificar as propriedades 
dos certificados dispensados pelo CA4 que associam os titulares de certificado à 
organização R4. O NC4 pode usar esse MSP nas suas políticas para conceder aos 
atores do R4 direitos específicos sobre os recursos de rede. Um exemplo dessa 
política é identificar os administradores no R4 que podem adicionar novas 
organizações membros à rede. Não mostramos MSPs nesses diagramas, pois eles 
gerariam confusão, mas são muito importantes.

Em segundo lugar, veremos mais adiante como os certificados emitidos pelas CAs 
estão no centro do processo de geração e validação da [transação](../glossary.html#transacao). 
Especificamente, os certificados X.509 são usados no aplicativo cliente 
[solicitador da transação](../glossary.html#proposta) e no contrato inteligente 
da [resposta de transação](../glossary.html#Endorsement) para assinar digitalmente 
[transações](../glossary.html#transaction). Posteriormente, os nós da rede que 
hospedam cópias do livro-razão verificam se as assinaturas da transação são 
válidas antes de aceitar as transações no livro-razão.

Vamos recapitular, a estrutura básica de nossa rede blockchain de exemplo. Há um
recurso, a rede N, acessada por um conjunto de usuários definidos por uma 
autoridade de certificação CA4, que possui um conjunto de direitos sobre os 
recursos na rede N, conforme descrito pelas políticas contidas em uma 
configuração de rede NC4. Tudo isso se torna real quando configuramos e iniciamos
o nó de serviço de ordens O4.

## Adicionando Administradores de Rede

O NC4 foi configurado inicialmente para permitir apenas aos usuários R4 direitos 
administrativos na rede. Nesta próxima fase, permitiremos que os usuários da 
organização R1 administrem a rede. Vamos ver como a rede evolui:

![network.admins](./network.diagram.2.1.png)

*A organização R4 atualiza a configuração da rede para tornar a organização R1 
um administrador. Após esse ponto, R1 e R4 têm direitos iguais sobre a 
configuração de rede.*

Vemos a adição de uma nova organização R1 como administrador -- R1 e R4 agora 
têm direitos iguais sobre a rede. Também podemos ver que a autoridade de 
certificação CA1 foi adicionada -- ela pode ser usada para identificar os usuários 
da organização R1. Após esse ponto, os usuários de R1 e R4 podem administrar a 
rede.

Embora o nó de ordens, O4, esteja sendo executado na infraestrutura do R4, o R1
possui direitos administrativos compartilhados, desde que possa obter acesso à 
rede. Isso significa que R1 ou R4 pode atualizar a configuração de rede NC4 para 
permitir à organização R2 um subconjunto de operações de rede. Dessa maneira, 
mesmo que o R4 esteja executando o serviço de ordens e o R1 possua direitos 
administrativos completos, o R2 possui direitos limitados para criar novos 
consórcios.

Na sua forma mais simples, o serviço de ordens é um único nó na rede, e é isso 
que você pode ver no exemplo. Os serviços de ordens geralmente são com vários 
nós e podem ser configurados para ter nós diferentes em diferentes organizações. 
Por exemplo, podemos executar o O4 no R4 e conectá-lo ao O2, um nó de ordem 
separado na organização R1. Dessa forma, teríamos uma estrutura de administração 
de vários sites e várias organizações.

Discutiremos o serviço de ordens um pouco [mais adiante neste tópico](#the-ordering-service), 
mas, por enquanto, apenas pense no serviço de ordens como um ponto de 
administração que fornece acesso controlado à rede a diferentes organizações.

## Definindo um Consórcio

Embora a rede agora possa ser administrada por R1 e R4, muito pouco pode ser 
feito. A primeira coisa que precisamos fazer é definir um consórcio. Essa 
palavra significa literalmente "um grupo com um destino compartilhado", por isso 
é uma escolha apropriada para um conjunto de organizações em uma rede blockchain.

Vamos ver como um consórcio é definido:

![network.consortium](./network.diagram.3.png)

*Um administrador de rede define um consórcio X1 que contém dois membros, as 
organizações R1 e R2. Essa definição de consórcio é armazenada na configuração 
de rede NC4 e será usada no próximo estágio de desenvolvimento da rede. CA1 e
CA2 são as respectivas autoridades de certificação dessas organizações.* 

Devido à maneira como o NC4 está configurado, apenas R1 ou R4 podem criar novos 
consórcios. Este diagrama mostra a adição de um novo consórcio, X1, que define 
R1 e R2 como suas organizações constituintes. Também podemos ver que o CA2 foi 
adicionado para identificar usuários do R2. Observe que um consórcio pode ter 
qualquer número de membros da organização -- acabamos de mostrar dois, pois é a
configuração mais simples.

Por que os consórcios são importantes? Podemos ver que um consórcio define o 
conjunto de organizações na rede que compartilham a necessidade de **transacionar** 
entre si -- nesse caso, R1 e R2. Realmente faz sentido agrupar organizações se 
elas têm um objetivo comum, e é exatamente isso que está acontecendo.

A rede, embora iniciada por uma única organização, agora é controlada por um 
conjunto maior de organizações. Poderíamos ter começado dessa maneira, com R1, 
R2 e R4 tendo controle compartilhado, mas essa estrutura facilita a compreensão.

Agora vamos usar o consórcio X1 para criar uma parte realmente importante de uma 
blockchain na Hyperledger Fabric -- **um canal**.

## Criando um Canal para um Consórcio

Então, vamos criar essa parte essencial da rede blockchain Fabric -- **um canal**. 
Um canal é o mecanismo de comunicação principal pelo qual os membros de um 
consórcio podem se comunicar. Pode haver vários canais em uma rede, mas, por 
enquanto, começaremos com um.

Vamos ver como o primeiro canal foi adicionado à rede:

![network.channel](./network.diagram.4.png)

*O canal C1 foi criado para R1 e R2 usando a definição de consórcio X1. O canal 
é governado por uma configuração de canal CC1, completamente separada da 
configuração de rede. CC1 é gerenciado por R1 e R2 que têm direitos iguais sobre 
C1. R4 não tem nenhum direito no CC1.*

O canal C1 fornece um mecanismo de comunicação privado para o consórcio X1. 
Podemos ver que o canal C1 foi conectado ao serviço de pedidos O4, mas que nada 
mais está anexado a ele. No próximo estágio do desenvolvimento da rede, 
conectaremos componentes como aplicativos clientes e nós de mesmo nível. Mas, 
neste ponto, um canal representa o **potencial** para conectividade futura.

Embora o canal C1 faça parte da rede N, ele é bastante distinto dela. Observe 
também que as organizações R3 e R4 não estão neste canal -- é para processamento 
de transações entre R1 e R2. Na etapa anterior, vimos como o R4 poderia conceder
permissão ao R1 para criar novos consórcios. É útil mencionar que o R4 **também** 
permitiu ao R1 criar canais! Neste diagrama, poderia ter sido a organização R1 
ou R4 que criou um canal C1. Novamente, observe que um canal pode ter qualquer 
número de organizações conectadas a ele -- mostramos dois pois é a configuração 
mais simples.

Novamente, observe como o canal C1 possui uma configuração completamente separada, 
CC1, na configuração de rede NC4. O CC1 contém as políticas que governam os 
direitos que R1 e R2 têm sobre o canal C1 -- e, como vimos, R3 e R4 não têm 
permissões nesse canal. R3 e R4 podem interagir apenas com C1 se forem 
adicionados por R1 ou R2 à política apropriada na configuração de canal CC1. Um 
exemplo é definir quem pode adicionar uma nova organização ao canal. 
Especificamente, observe que R4 não pode se adicionar ao canal C1 -- deve e só 
pode ser autorizado por R1 ou R2.

Por que os canais são tão importantes? Os canais são úteis porque fornecem um 
mecanismo para comunicações e dados privados entre os membros de um consórcio. 
Os canais fornecem privacidade em relação a outros canais e da rede. A 
Hyperledger Fabric é poderosa nesse sentido, pois permite que as organizações 
compartilhem a infraestrutura e a mantenham privadas ao mesmo tempo. Não há 
contradição aqui -- diferentes consórcios na rede precisarão compartilhar 
informações e processos diferentes de maneira apropriada, e os canais fornecem 
um mecanismo eficiente para fazer isso. Os canais fornecem um compartilhamento 
eficiente da infraestrutura, mantendo a privacidade dos dados e das comunicações.

Também podemos ver que, uma vez que um canal foi criado, ele é, em um sentido 
muito real, "livre da rede". Somente as organizações especificadas explicitamente
em uma configuração de canal têm controle sobre ela, deste momento em diante para 
o futuro. Da mesma forma, quaisquer atualizações na configuração de rede NC4 a 
partir de agora não terão efeito direto na configuração de canal CC1, por 
exemplo, se a definição do consórcio X1 for alterada, ela não afetará os membros 
do canal C1. Os canais são, portanto, úteis porque permitem comunicações privadas
entre as organizações que constituem o canal. Além disso, os dados em um canal 
são completamente isolados do restante da rede, incluindo outros canais.

Além disso, há também um **canal de sistema** especial definido para uso pelo 
serviço de ordens. Ele se comporta exatamente da mesma maneira que um canal 
comum, às vezes chamado de **canais de aplicativos** por esse motivo. Normalmente, 
não precisamos nos preocupar com esse canal, mas discutiremos um pouco mais sobre 
isso [mais adiante neste tópico](#the-ordering-service).

## Peers and Ledgers

Let's now start to use the channel to connect the blockchain network and the
organizational components together. In the next stage of network development, we
can see that our network N has just acquired two new components, namely a peer
node P1 and a ledger instance, L1.

![network.peersledger](./network.diagram.5.png)

*A peer node P1 has joined the channel C1. P1 physically hosts a copy of the
ledger L1. P1 and O4 can communicate with each other using channel C1.*

Peer nodes are the network components where copies of the blockchain ledger are
hosted!  At last, we're starting to see some recognizable blockchain components!
P1's purpose in the network is purely to host a copy of the ledger L1 for others
to access. We can think of L1 as being **physically hosted** on P1, but
**logically hosted** on the channel C1. We'll see this idea more clearly when we
add more peers to the channel.

A key part of a P1's configuration is an X.509 identity issued by CA1 which
associates P1 with organization R1. Once P1 is started, it can **join** channel
C1 using the orderer O4. When O4 receives this join request, it uses the channel
configuration CC1 to determine P1's permissions on this channel. For example,
CC1 determines whether P1 can read and/or write information to the ledger L1.

Notice how peers are joined to channels by the organizations that own them, and
though we've only added one peer, we'll see how  there can be multiple peer
nodes on multiple channels within the network. We'll see the different roles
that peers can take on a little later.

## Applications and Smart Contract chaincode

Now that the channel C1 has a ledger on it, we can start connecting client
applications to consume some of the services provided by workhorse of the
ledger, the peer!

Notice how the network has grown:

![network.appsmartcontract](./network.diagram.6.png)

*A smart contract S5 has been installed onto P1.  Client application A1 in
organization R1 can use S5 to access the ledger via peer node P1. A1, P1 and
O4 are all joined to channel C1, i.e. they can all make use of the
communication facilities provided by that channel.*

In the next stage of network development, we can see that client application A1
can use channel C1 to connect to specific network resources -- in this case A1
can connect to both peer node P1 and orderer node O4. Again, see how channels
are central to the communication between network and organization components.
Just like peers and orderers, a client application will have an identity that
associates it with an organization.  In our example, client application A1 is
associated with organization R1; and although it is outside the Fabric
blockchain network, it is connected to it via the channel C1.

It might now appear that A1 can access the ledger L1 directly via P1, but in
fact, all access is managed via a special program called a smart contract
chaincode, S5. Think of S5 as defining all the common access patterns to the
ledger; S5 provides a well-defined set of ways by which the ledger L1 can
be queried or updated. In short, client application A1 has to go through smart
contract S5 to get to ledger L1!

Smart contracts can be created by application developers in each organization to
implement a business process shared by the consortium members. Smart contracts
are used to help generate transactions which can be subsequently distributed to
every node in the network. We'll discuss this idea a little later; it'll be
easier to understand when the network is bigger. For now, the important thing to
understand is that to get to this point two operations must have been performed
on the smart contract; it must have been **installed** on peers, and then
**defined** on a channel.

Hyperledger Fabric users often use the terms **smart contract** and
**chaincode** interchangeably. In general, a smart contract defines the
**transaction logic** that controls the lifecycle of a business object contained
in the world state. It is then packaged into a chaincode which is then deployed
to a blockchain network. Think of smart contracts as governing transactions,
whereas chaincode governs how smart contracts are packaged for deployment.

### Installing a chaincode package

After a smart contract S5 has been developed, an administrator in organization
R1 must create a chaincode package and [install](../glossary.html#install) it
onto peer node P1. This is a straightforward operation; once completed, P1 has
full knowledge of S5. Specifically, P1 can see the **implementation** logic of
S5 -- the program code that it uses to access the ledger L1. We contrast this to
the S5 **interface** which merely describes the inputs and outputs of S5,
without regard to its implementation.

When an organization has multiple peers in a channel, it can choose the peers
upon which it installs smart contracts; it does not need to install a smart
contract on every peer.

### Defining a chaincode

Although a chaincode is installed on the peers of individual organizations, it
is governed and operated in the scope of a channel. Each organization needs to
approve a **chaincode definition**, a set of parameters that establish how a
chaincode will be used on a channel. An organization must approve a chaincode
definition in order to use the installed smart contract to query the ledger
and endorse transactions. In our example, which only has a single peer node P1,
an administrator in organization R1 must approve a chaincode definition for S5.

A sufficient number of organizations need to approve a chaincode definition (A
majority, by default) before the chaincode definition can be committed to the
channel and used to interact with the channel ledger. Because the channel only
has one member, the administrator of R1 can commit the chaincode definition of
S5 to the channel C1. Once the definition has been committed, S5 can now be
[invoked](../glossary.html#invoke) by client application A1!

Note that although every component on the channel can now access S5, they are
not able to see its program logic.  This remains private to those nodes who have
installed it; in our example that means P1. Conceptually this means that it's
the smart contract **interface** that is defined and committed to a channel, in
contrast to the smart contract **implementation** that is installed. To reinforce
this idea; installing a smart contract shows how we think of it being
**physically hosted** on a peer, whereas a smart contract that has been defined
on a channel shows how we consider it **logically hosted** by the channel.

### Endorsement policy

The most important piece of information supplied within the chaincode definition
is the [endorsement policy](../glossary.html#endorsement-policy). It describes
which organizations must approve transactions before they will be accepted by other
organizations onto their copy of the ledger. In our sample network, transactions
can only be accepted onto ledger L1 if R1 or R2 endorse them.

Committing the chaincode definition to the channel places the endorsement policy
on the channel ledger; it enables it to be accessed by any member of the channel.
You can read more about endorsement policies in the [transaction flow topic](../txflow.html).

### Invoking a smart contract

Once a smart contract has been installed on a peer node and defined on a
channel it can be [invoked](../glossary.html#invoke) by a client application.
Client applications do this by sending transaction proposals to peers owned by
the organizations specified by the smart contract endorsement policy. The
transaction proposal serves as input to the smart contract, which uses it to
generate an endorsed transaction response, which is returned by the peer node to
the client application.

It's these transactions responses that are packaged together with the
transaction proposal to form a fully endorsed transaction, which can be
distributed to the entire network.  We'll look at this in more detail later  For
now, it's enough to understand how applications invoke smart contracts to
generate endorsed transactions.

By this stage in network development we can see that organization R1 is fully
participating in the network. Its applications -- starting with A1 -- can access
the ledger L1 via smart contract S5, to generate transactions that will be
endorsed by R1, and therefore accepted onto the ledger because they conform to
the endorsement policy.

## Network completed

Recall that our objective was to create a channel for consortium X1 --
organizations R1 and R2. This next phase of network development sees
organization R2 add its infrastructure to the network.

Let's see how the network has evolved:

![network.grow](./network.diagram.7.png)

*The network has grown through the addition of infrastructure from
organization R2. Specifically, R2 has added peer node P2, which hosts a copy of
ledger L1, and chaincode S5. R2 approves the same chaincode definition as R1.
P2 has also joined channel C1, as has application A2. A2 and P2 are identified
using certificates from CA2. All of this means that both applications A1 and A2
can invoke S5 on C1 either using peer node P1 or P2.*

We can see that organization R2 has added a peer node, P2, on channel C1. P2
also hosts a copy of the ledger L1 and smart contract S5. We can see that R2 has
also added client application A2 which can connect to the network via channel
C1. To achieve this, an administrator in organization R2 has created peer node
P2 and joined it to channel C1, in the same way as an administrator in R1. The
administrator also has to approve the same chaincode definition as R1.

We have created our first operational network! At this stage in network
development, we have a channel in which organizations R1 and R2 can fully
transact with each other. Specifically, this means that applications A1 and A2
can generate transactions using smart contract S5 and ledger L1 on channel C1.

### Generating and accepting transactions

In contrast to peer nodes, which always host a copy of the ledger, we see that
there are two different kinds of peer nodes; those which host smart contracts
and those which do not. In our network, every peer hosts a copy of the smart
contract, but in larger networks, there will be many more peer nodes that do not
host a copy of the smart contract. A peer can only *run* a smart contract if it
is installed on it, but it can *know* about the interface of a smart contract by
being connected to a channel.

You should not think of peer nodes which do not have smart contracts installed
as being somehow inferior. It's more the case that peer nodes with smart
contracts have a special power -- to help **generate** transactions. Note that
all peer nodes can **validate** and subsequently **accept** or **reject**
transactions onto their copy of the ledger L1. However, only peer nodes with a
smart contract installed can take part in the process of transaction
**endorsement** which is central to the generation of valid transactions.

We don't need to worry about the exact details of how transactions are
generated, distributed and accepted in this topic -- it is sufficient to
understand that we have a blockchain network where organizations R1 and R2 can
share information and processes as ledger-captured transactions.  We'll learn a
lot more about transactions, ledgers, smart contracts in other topics.

### Types of peers

In Hyperledger Fabric, while all peers are the same, they can assume multiple
roles depending on how the network is configured.  We now have enough
understanding of a typical network topology to describe these roles.

  * [*Committing peer*](../glossary.html#commitment). Every peer node in a
    channel is a committing peer. It receives blocks of generated transactions,
    which are subsequently validated before they are committed to the peer
    node's copy of the ledger as an append operation.

  * [*Endorsing peer*](../glossary.html#endorsement). Every peer with a smart
    contract *can* be an endorsing peer if it has a smart contract installed.
    However, to actually *be* an endorsing peer, the smart contract on the peer
    must be used by a client application to generate a digitally signed
    transaction response. The term *endorsing peer* is an explicit reference to
    this fact.

    An endorsement policy for a smart contract identifies the
    organizations whose peer should digitally sign a generated transaction
    before it can be accepted onto a committing peer's copy of the ledger.

These are the two major types of peer; there are two other roles a peer can
adopt:

  * [*Leader peer*](../glossary.html#leading-peer). When an organization has
    multiple peers in a channel, a leader peer is a node which takes
    responsibility for distributing transactions from the orderer to the other
    committing peers in the organization.  A peer can choose to participate in
    static or dynamic leadership selection.

    It is helpful, therefore to think of two sets of peers from leadership
    perspective -- those that have static leader selection, and those with
    dynamic leader selection. For the static set, zero or more peers can be
    configured as leaders. For the dynamic set, one peer will be elected leader
    by the set. Moreover, in the dynamic set, if a leader peer fails, then the
    remaining peers will re-elect a leader.

    It means that an organization's peers can have one or more leaders connected
    to the ordering service. This can help to improve resilience and scalability
    in large networks which process high volumes of transactions.

  * [*Anchor peer*](../glossary.html#anchor-peer). If a peer needs to
    communicate with a peer in another organization, then it can use one of the
    **anchor peers** defined in the channel configuration for that organization.
    An organization can have zero or more anchor peers defined for it, and an
    anchor peer can help with many different cross-organization communication
    scenarios.

Note that a peer can be a committing peer, endorsing peer, leader peer and
anchor peer all at the same time! Only the anchor peer is optional -- for all
practical purposes there will always be a leader peer and at least one
endorsing peer and at least one committing peer.

### Adding organizations and peers to the channel

When R2 joins the channel, the organization must install smart contract S5
onto its peer node, P2. That's obvious -- if applications A1 or A2 wish to use
S5 on peer node P2 to generate transactions, it must first be present;
installation is the mechanism by which this happens. At this point, peer node P2
has a physical copy of the smart contract and the ledger; like P1, it can both
generate and accept transactions onto its copy of ledger L1.

R2 must approve the same chaincode definition as was approved by R1 in order to
use smart contract S5. Because the chaincode definition has already been
committed to the channel by organization R1, R2 can use the chaincode as soon as
the organization approves the chaincode definition and installs the chaincode
package. The commit transaction only needs to happen once. A new organization
can use the chaincode as soon as they approve the chaincode parameters agreed to
by other members of the channel. Because the approval of a chaincode definition
occurs at the organization level, R2 can approve the chaincode definition once
and join multiple peers to the channel with the chaincode package installed.
However, if R2 wanted to change the chaincode definition, both R1 and R2 would
need to approve a new definition for their organization, and then one of the
organizations would need to commit the definition to the channel.

In our network, we can see that channel C1 connects two client applications, two
peer nodes and an ordering service.  Since there is only one channel, there is
only one **logical** ledger with which these components interact. Peer nodes P1
and P2 have identical copies of ledger L1. Copies of smart contract S5 will
usually be identically implemented using the same programming language, but
if not, they must be semantically equivalent.

We can see that the careful addition of peers to the network can help support
increased throughput, stability, and resilience. For example, more peers in a
network will allow more applications to connect to it; and multiple peers in an
organization will provide extra resilience in the case of planned or unplanned
outages.

It all means that it is possible to configure sophisticated topologies which
support a variety of operational goals -- there is no theoretical limit to how
big a network can get. Moreover, the technical mechanism by which peers within
an individual organization efficiently discover and communicate with each other --
the [gossip protocol](../gossip.html#gossip-protocol) -- will accommodate a
large number of peer nodes in support of such topologies.

The careful use of network and channel policies allow even large networks to be
well-governed.  Organizations are free to add peer nodes to the network so long
as they conform to the policies agreed by the network. Network and channel
policies create the balance between autonomy and control which characterizes a
de-centralized network.

## Simplifying the visual vocabulary

We’re now going to simplify the visual vocabulary used to represent our sample
blockchain network. As the size of the network grows, the lines initially used
to help us understand channels will become cumbersome. Imagine how complicated
our diagram would be if we added another peer or client application, or another
channel?

That's what we're going to do in a minute, so before we do, let's simplify the
visual vocabulary. Here's a simplified representation of the network we've
developed so far:

![network.vocabulary](./network.diagram.8.png)

*The diagram shows the facts relating to channel C1 in the network N as follows:
Client applications A1 and A2 can use channel C1 for communication with peers
P1 and P2, and orderer O4. Peer nodes P1 and P2 can use the communication
services of channel C1. Ordering service O4 can make use of the communication
services of channel C1. Channel configuration CC1 applies to channel C1.*

Note that the network diagram has been simplified by replacing channel lines
with connection points, shown as blue circles which include the channel number.
No information has been lost. This representation is more scalable because it
eliminates crossing lines. This allows us to more clearly represent larger
networks. We've achieved this simplification by focusing on the connection
points between components and a channel, rather than the channel itself.

## Adding another consortium definition

In this next phase of network development, we introduce organization R3.  We're
going to give organizations R2 and R3 a separate application channel which
allows them to transact with each other.  This application channel will be
completely separate to that previously defined, so that R2 and R3 transactions
can be kept private to them.

Let's return to the network level and define a new consortium, X2, for R2 and
R3:

![network.consortium2](./network.diagram.9.png)

*A network administrator from organization R1 or R4 has added a new consortium
definition, X2, which includes organizations R2 and R3. This will be used to
define a new channel for X2.*

Notice that the network now has two consortia defined: X1 for organizations R1
and R2 and X2 for organizations R2 and R3. Consortium X2 has been introduced in
order to be able to create a new channel for R2 and R3.

A new channel can only be created by those organizations specifically identified
in the network configuration policy, NC4, as having the appropriate rights to do
so, i.e. R1 or R4. This is an example of a policy which separates organizations
that can manage resources at the network level versus those who can manage
resources at the channel level. Seeing these policies at work helps us
understand why Hyperledger Fabric has a sophisticated **tiered** policy
structure.

In practice, consortium definition X2 has been added to the network
configuration NC4. We discuss the exact mechanics of this operation elsewhere in
the documentation.

## Adding a new channel

Let's now use this new consortium definition, X2, to create a new channel, C2.
To help reinforce your understanding of the simpler channel notation, we've used
both visual styles -- channel C1 is represented with blue circular end points,
whereas channel C2 is represented with red connecting lines:

![network.channel2](./network.diagram.10.png)

*A new channel C2 has been created for R2 and R3 using consortium definition X2.
The channel has a channel configuration CC2, completely separate to the network
configuration NC4, and the channel configuration CC1. Channel C2 is managed by
R2 and R3 who have equal rights over C2 as defined by a policy in CC2. R1 and
R4 have no rights defined in CC2 whatsoever.*

The channel C2 provides a private communications mechanism for the consortium
X2. Again, notice how organizations united in a consortium are what form
channels. The channel configuration CC2 now contains the policies that govern
channel resources, assigning management rights to organizations R2 and R3 over
channel C2. It is managed exclusively by R2 and R3; R1 and R4 have no power in
channel C2. For example, channel configuration CC2 can subsequently be updated
to add organizations to support network growth, but this can only be done by R2
or R3.

Note how the channel configurations CC1 and CC2 remain completely separate from
each other, and completely separate from the network configuration, NC4. Again
we're seeing the de-centralized nature of a Hyperledger Fabric network; once
channel C2 has been created, it is managed by organizations R2 and R3
independently to other network elements. Channel policies always remain separate
from each other and can only be changed by the organizations authorized to do so
in the channel.

As the network and channels evolve, so will the network and channel
configurations. There is a process by which this is accomplished in a controlled
manner -- involving configuration transactions which capture the change to these
configurations. Every configuration change results in a new configuration block
transaction being generated, and [later in this topic](#the-ordering-serivce),
we'll see how these blocks are validated and accepted to create updated network
and channel configurations respectively.

### Network and channel configurations

Throughout our sample network, we see the importance of network and channel
configurations. These configurations are important because they encapsulate the
**policies** agreed by the network members, which provide a shared reference for
controlling access to network resources. Network and channel configurations also
contain **facts** about the network and channel composition, such as the name of
consortia and its organizations.

For example, when the network is first formed using the ordering service node
O4, its behaviour is governed by the network configuration NC4. The initial
configuration of NC4 only contains policies that permit organization R4 to
manage network resources. NC4 is subsequently updated to also allow R1 to manage
network resources. Once this change is made, any administrator from organization
R1 or R4 that connects to O4 will have network management rights because that is
what the policy in the network configuration NC4 permits. Internally, each node
in the ordering service records each channel in the network configuration, so
that there is a record of each channel created, at the network level.

It means that although ordering service node O4 is the actor that created
consortia X1 and X2 and channels C1 and C2, the **intelligence** of the network
is contained in the network configuration NC4 that O4 is obeying.  As long as O4
behaves as a good actor, and correctly implements the policies defined in NC4
whenever it is dealing with network resources, our network will behave as all
organizations have agreed. In many ways NC4 can be considered more important
than O4 because, ultimately, it controls network access.

The same principles apply for channel configurations with respect to peers. In
our network, P1 and P2 are likewise good actors. When peer nodes P1 and P2 are
interacting with client applications A1 or A2 they are each using the policies
defined within channel configuration CC1 to control access to the channel C1
resources.

For example, if A1 wants to access the smart contract chaincode S5 on peer nodes
P1 or P2, each peer node uses its copy of CC1 to determine the operations that
A1 can perform. For example, A1 may be permitted to read or write data from the
ledger L1 according to policies defined in CC1. We'll see later the same pattern
for actors in channel and its channel configuration CC2.  Again, we can see that
while the peers and applications are critical actors in the network, their
behaviour in a channel is dictated more by the channel configuration policy than
any other factor.

Finally, it is helpful to understand how network and channel configurations are
physically realized. We can see that network and channel configurations are
logically singular -- there is one for the network, and one for each channel.
This is important; every component that accesses the network or the channel must
have a shared understanding of the permissions granted to different
organizations.

Even though there is logically a single configuration, it is actually replicated
and kept consistent by every node that forms the network or channel. For
example, in our network peer nodes P1 and P2 both have a copy of channel
configuration CC1, and by the time the network is fully complete, peer nodes P2
and P3 will both have a copy of channel configuration CC2. Similarly ordering
service node O4 has a copy of the network configuration, but in a [multi-node
configuration](#the-ordering-service), every ordering service node will have its
own copy of the network configuration.

Both network and channel configurations are kept consistent using the same
blockchain technology that is used for user transactions -- but for
**configuration** transactions. To change a network or channel configuration, an
administrator must submit a configuration transaction to change the network or
channel configuration. It must be signed by the organizations identified in the
appropriate policy as being responsible for configuration change. This policy is
called the **mod_policy** and we'll [discuss it later](#changing-policy).

Indeed, the ordering service nodes operate a mini-blockchain, connected via the
**system channel** we mentioned earlier. Using the system channel ordering
service nodes distribute network configuration transactions. These transactions
are used to co-operatively maintain a consistent copy of the network
configuration at each ordering service node. In a similar way, peer nodes in an
**application channel** can distribute channel configuration transactions.
Likewise, these transactions are used to maintain a consistent copy of the
channel configuration at each peer node.

This balance between objects that are logically singular, by being physically
distributed is a common pattern in Hyperledger Fabric. Objects like network
configurations, that are logically single, turn out to be physically replicated
among a set of ordering services nodes for example. We also see it with channel
configurations, ledgers, and to some extent smart contracts which are installed
in multiple places but whose interfaces exist logically at the channel level.
It's a pattern you see repeated time and again in Hyperledger Fabric, and
enables Hyperledger Fabric to be both de-centralized and yet manageable at the
same time.

## Adding another peer

Now that organization R3 is able to fully participate in channel C2, let's add
its infrastructure components to the channel.  Rather than do this one component
at a time, we're going to add a peer, its local copy of a ledger, a smart
contract and a client application all at once!

Let's see the network with organization R3's components added:

![network.peer2](./network.diagram.11.png)

*The diagram shows the facts relating to channels C1 and C2 in the network N as
follows: Client applications A1 and A2 can use channel C1 for communication
with peers P1 and P2, and ordering service O4; client applications A3 can use
channel C2 for communication with peer P3 and ordering service O4. Ordering
service O4 can make use of the communication services of channels C1 and C2.
Channel configuration CC1 applies to channel C1, CC2 applies to channel C2.*

First of all, notice that because peer node P3 is connected to channel C2, it
has a **different** ledger -- L2 -- to those peer nodes using channel C1.  The
ledger L2 is effectively scoped to channel C2. The ledger L1 is completely
separate; it is scoped to channel C1.  This makes sense -- the purpose of the
channel C2 is to provide private communications between the members of the
consortium X2, and the ledger L2 is the private store for their transactions.

In a similar way, the smart contract S6, installed on peer node P3, and defined
on channel C2, is used to provide controlled access to ledger L2. Application A3
can now use channel C2 to invoke the services provided by smart contract S6 to
generate transactions that can be accepted onto every copy of the ledger L2 in
the network.

At this point in time, we have a single network that has two completely separate
channels defined within it.  These channels provide independently managed
facilities for organizations to transact with each other. Again, this is
de-centralization at work; we have a balance between control and autonomy. This
is achieved through policies which are applied to channels which are controlled
by, and affect, different organizations.

## Joining a peer to multiple channels

In this final stage of network development, let's return our focus to
organization R2. We can exploit the fact that R2 is a member of both consortia
X1 and X2 by joining it to multiple channels:

![network.multichannel](./network.diagram.12.png)

*The diagram shows the facts relating to channels C1 and C2 in the network N as
follows: Client applications A1 can use channel C1 for communication with peers
P1 and P2, and ordering service O4; client application A2 can use channel C1
for communication with peers P1 and P2 and channel C2 for communication with
peers P2 and P3 and ordering service O4; client application A3 can use channel
C2 for communication with peer P3 and P2 and ordering service O4. Ordering service O4
can make use of the communication services of channels C1 and C2. Channel
configuration CC1 applies to channel C1, CC2 applies to channel C2.*

We can see that R2 is a special organization in the network, because it is the
only organization that is a member of two application channels!  It is able to
transact with organization R1 on channel C1, while at the same time it can also
transact with organization R3 on a different channel, C2.

Notice how peer node P2 has smart contract S5 installed for channel C1 and smart
contract S6 installed for channel C2. Peer node P2 is a full member of both
channels at the same time via different smart contracts for different ledgers.

This is a very powerful concept -- channels provide both a mechanism for the
separation of organizations, and a mechanism for collaboration between
organizations. All the while, this infrastructure is provided by, and shared
between, a set of independent organizations.

It is also important to note that peer node P2's behaviour is controlled very
differently depending upon the channel in which it is transacting. Specifically,
the policies contained in channel configuration CC1 dictate the operations
available to P2 when it is transacting in channel C1, whereas it is the policies
in channel configuration CC2 that control P2's behaviour in channel C2.

Again, this is desirable -- R2 and R1 agreed the rules for channel C1, whereas
R2 and R3 agreed the rules for channel C2. These rules were captured in the
respective channel policies -- they can and must be used by every
component in a channel to enforce correct behaviour, as agreed.

Similarly, we can see that client application A2 is now able to transact on
channels C1 and C2.  And likewise, it too will be governed by the policies in
the appropriate channel configurations.  As an aside, note that client
application A2 and peer node P2 are using a mixed visual vocabulary -- both
lines and connections. You can see that they are equivalent; they are visual
synonyms.

### The ordering service

The observant reader may notice that the ordering service node appears to be a
centralized component; it was used to create the network initially, and connects
to every channel in the network.  Even though we added R1 and R4 to the network
configuration policy NC4 which controls the orderer, the node was running on
R4's infrastructure. In a world of de-centralization, this looks wrong!

Don't worry! Our example network showed the simplest ordering service
configuration to help you understand the idea of a network administration point.
In fact, the ordering service can itself too be completely de-centralized!  We
mentioned earlier that an ordering service could be comprised of many individual
nodes owned by different organizations, so let's see how that would be done in
our sample network.

Let's have a look at a more realistic ordering service node configuration:

![network.finalnetwork2](./network.diagram.15.png)

*A multi-organization ordering service.  The ordering service comprises ordering
service nodes O1 and O4. O1 is provided by organization R1 and node O4 is
provided by organization R4. The network configuration NC4 defines network
resource permissions for actors from both organizations R1 and R4.*

We can see that this ordering service completely de-centralized -- it runs in
organization R1 and it runs in organization R4. The network configuration
policy, NC4, permits R1 and R4 equal rights over network resources.  Client
applications and peer nodes from organizations R1 and R4 can manage network
resources by connecting to either node O1 or node O4, because both nodes behave
the same way, as defined by the policies in network configuration NC4. In
practice, actors from a particular organization *tend* to use infrastructure
provided by their home organization, but that's certainly not always the case.

### De-centralized transaction distribution

As well as being the management point for the network, the ordering service also
provides another key facility -- it is the distribution point for transactions.
The ordering service is the component which gathers endorsed transactions
from applications and orders them into transaction blocks, which are
subsequently distributed to every peer node in the channel. At each of these
committing peers, transactions are recorded, whether valid or invalid, and their
local copy of the ledger updated appropriately.

Notice how the ordering service node O4 performs a very different role for the
channel C1 than it does for the network N. When acting at the channel level,
O4's role is to gather transactions and distribute blocks inside channel C1. It
does this according to the policies defined in channel configuration CC1. In
contrast, when acting at the network level, O4's role is to provide a management
point for network resources according to the policies defined in network
configuration NC4. Notice again how these roles are defined by different
policies within the channel and network configurations respectively. This should
reinforce to you the importance of declarative policy based configuration in
Hyperledger Fabric. Policies both define, and are used to control, the agreed
behaviours by each and every member of a consortium.

We can see that the ordering service, like the other components in Hyperledger
Fabric, is a fully de-centralized component. Whether acting as a network
management point, or as a distributor of blocks in a channel, its nodes can be
distributed as required throughout the multiple organizations in a network.

### Changing policy

Throughout our exploration of the sample network, we've seen the importance of
the policies to control the behaviour of the actors in the system. We've only
discussed a few of the available policies, but there are many that can be
declaratively defined to control every aspect of behaviour. These individual
policies are discussed elsewhere in the documentation.

Most importantly of all, Hyperledger Fabric provides a uniquely powerful policy
that allows network and channel administrators to manage policy change itself!
The underlying philosophy is that policy change is a constant, whether it occurs
within or between organizations, or whether it is imposed by external
regulators. For example, new organizations may join a channel, or existing
organizations may have their permissions increased or decreased. Let's
investigate a little more how change policy is implemented in Hyperledger
Fabric.

The key point of understanding is that policy change is managed by a
policy within the policy itself.  The **modification policy**, or
**mod_policy** for short, is a first class policy within a network or channel
configuration that manages change. Let's give two brief examples of how we've
**already** used mod_policy to manage change in our network!

The first example was when the network was initially set up. At this time, only
organization R4 was allowed to manage the network. In practice, this was
achieved by making R4 the only organization defined in the network configuration
NC4 with permissions to network resources.  Moreover, the mod_policy for NC4
only mentioned organization R4 -- only R4 was allowed to change this
configuration.

We then evolved the network N to also allow organization R1 to administer the
network.  R4 did this by adding R1 to the policies for channel creation and
consortium creation. Because of this change, R1 was able to define the
consortia X1 and X2, and create the channels C1 and C2. R1 had equal
administrative rights over the channel and consortium policies in the network
configuration.

R4 however, could grant even more power over the network configuration to R1! R4
could add R1 to the mod_policy such that R1 would be able to manage change of
the network policy too.

This second power is much more powerful than the first, because R1 now has
**full control** over the network configuration NC4! This means that R1 can, in
principle remove R4's management rights from the network.  In practice, R4 would
configure the mod_policy such that R4 would need to also approve the change, or
that all organizations in the mod_policy would have to approve the change.
There's lots of flexibility to make the mod_policy as sophisticated as it needs
to be to support whatever change process is required.

This is mod_policy at work -- it has allowed the graceful evolution of a basic
configuration into a sophisticated one. All the time this has occurred with the
agreement of all organization involved. The mod_policy behaves like every other
policy inside a network or channel configuration; it defines a set of
organizations that are allowed to change the mod_policy itself.

We've only scratched the surface of the power of policies and mod_policy in
particular in this subsection. It is discussed at much more length in the policy
topic, but for now let's return to our finished network!

## Network fully formed

Let's recap what our network looks like using a consistent visual vocabulary.
We've re-organized it slightly using our more compact visual syntax, because it
better accommodates larger topologies:

![network.finalnetwork2](./network.diagram.14.png)

*In this diagram we see that the Fabric blockchain network consists of two
application channels and one ordering channel. The organizations R1 and R4 are
responsible for the ordering channel, R1 and R2 are responsible for the blue
application channel while R2 and R3 are responsible for the red application
channel. Client applications A1 is an element of organization R1, and CA1 is
it's certificate authority. Note that peer P2 of organization R2 can use the
communication facilities of the blue and the red application channel. Each
application channel has its own channel configuration, in this case CC1 and
CC2. The channel configuration of the system channel is part of the network
configuration, NC4.*

We're at the end of our conceptual journey to build a sample Hyperledger Fabric
blockchain network. We've created a four organization network with two channels
and three peer nodes, with two smart contracts and an ordering service.  It is
supported by four certificate authorities. It provides ledger and smart contract
services to three client applications, who can interact with it via the two
channels. Take a moment to look through the details of the network in the
diagram, and feel free to read back through the topic to reinforce your
knowledge, or go to a more detailed topic.

### Summary of network components

Here's a quick summary of the network components we've discussed:

* [Ledger](../glossary.html#ledger). One per channel. Comprised of the
  [Blockchain](../glossary.html#block) and
  the [World state](../glossary.html#world-state)
* [Smart contract](../glossary.html#smart-contract) (aka chaincode)
* [Peer nodes](../glossary.html#peer)
* [Ordering service](../glossary.html#ordering-service)
* [Channel](../glossary.html#channel)
* [Certificate Authority](../glossary.html#hyperledger-fabric-ca)

## Network summary

In this topic, we've seen how different organizations share their infrastructure
to provide an integrated Hyperledger Fabric blockchain network.  We've seen how
the collective infrastructure can be organized into channels that provide
private communications mechanisms that are independently managed.  We've seen
how actors such as client applications, administrators, peers and orderers are
identified as being from different organizations by their use of certificates
from their respective certificate authorities.  And in turn, we've seen the
importance of policy to define the agreed permissions that these organizational
actors have over network and channel resources.
