Glossário
=========

A terminologia é muito importante, para que todos os usuários e desenvolvedores 
da Hyperledger Fabric concordem com o que queremos dizer com cada termo específico. 
O que é um contrato inteligente, por exemplo. A documentação fará referência ao 
glossário conforme necessário, mas fique à vontade para ler a coisa toda de uma 
só vez, se quiser; é bem esclarecedor! 

.. _glossary_ACL:

ACL
---

Uma ACL, ou Lista de Controle de Acesso, associa o acesso a recursos específicos 
(como APIs de chaincode ou serviços de eventos) a uma Política_ (que especifica 
quantos e quais tipos de organizações ou funções são necessários). A ACL faz 
parte da configuração de um canal. Portanto, ele persiste nos blocos de 
configuração do canal e pode ser atualizado usando o mecanismo de atualização de
configuração padrão.

Uma ACL é formatada como uma lista de pares de chave-valor, onde a chave 
identifica o recurso cujo acesso queremos controlar, e o valor identifica a 
política de canal (grupo) que tem permissão para acessá-lo. Por exemplo, 
``lscc/GetDeploymentSpec:/Channel/Application/Readers`` define que o acesso ao 
ciclo de vida da API ``GetDeploymentSpec`` (o recurso) é acessível por 
identidades que satisfazem a política ``/Channel/Application/Readers``.

Um conjunto de ACLs padrão é fornecido no arquivo ``configtx.yaml``, usado pelo 
configtxgen para criar configurações de canal. Os padrões podem ser definidos na
seção superior "Applications" do ``configtx.yaml`` ou sobrescritas pelo
perfil na seção "Profiles".

.. _Block:
.. _Bloco:

Bloco
-----

.. figure:: ./glossary/glossary.block.png
   :scale: 50 %
   :align: right
   :figwidth: 40 %
   :alt: Um Bloco

   O bloco B1 está ligado ao bloco B0. O bloco B2 está ligado ao bloco B1.

=======

Um bloco contém um conjunto ordenado de transações. Ele é criptograficamente 
vinculado ao bloco anterior e, por sua vez, é vinculado aos blocos subsequentes. 
O primeiro bloco dessa cadeia de blocos é chamado de **bloco de gênese**. Os 
blocos são criados pelo serviço de ordens, validados e confirmados pelos pares.


.. _Chain:

Chain
-----

.. figure:: ./glossary/glossary.blockchain.png
   :scale: 75 %
   :align: right
   :figwidth: 40 %
   :alt: Blockchain

   Blockchain B contêm os blocos 0, 1, 2.

=======

A cadeia do livro-razão é um log de transações estruturado como blocos de 
transações vinculados a um hash. Os pares recebem blocos de transações do serviço
de ordens, marcam as transações do bloco como válidas ou inválidas com base em 
políticas de endosso e violações de concorrência, e anexam o bloco à cadeia de
hash no sistema de arquivos do nó.

.. _chaincode:

Chaincode
---------

Veja Smart-Contract_.

.. _Channel:
.. _Canal:

Canal (Channel)
---------------

.. figure:: ./glossary/glossary.channel.png
   :scale: 30 %
   :align: right
   :figwidth: 40 %
   :alt: A Channel

   Channel C connects application A1, peer P2 and ordering service O1.

=======

A channel is a private blockchain overlay which allows for data
isolation and confidentiality. A channel-specific ledger is shared across the
peers in the channel, and transacting parties must be authenticated to
a channel in order to interact with it.  Channels are defined by a
[Configuration Block](#configuration-block).

.. _Commit:
.. _Confirmar:

Confirmar
---------

Cada par_ em um canal valida os blocos ordenados das transações e, em seguida, 
confirma (grava/acrescenta) os blocos à sua réplica do Livro-Razao_ do canal. Os 
pares também marcam cada transação em cada bloco como válida ou inválida.

.. _Concurrency-Control-Version-Check:

Concurrency Control Version Check
---------------------------------

Concurrency Control Version Check is a method of keeping ledger state in sync across
peers on a channel. Peers execute transactions in parallel, and before committing
to the ledger, peers check whether the state read at the time the transaction was executed
has been modified. If the data read for the transaction has changed between execution time and
commit time, then a Concurrency Control Version Check violation has
occurred, and the transaction is marked as invalid on the ledger and values
are not updated in the state database.

.. _Configuration-Block:

Configuration Block
-------------------

Contains the configuration data defining members and policies for a system
chain (ordering service) or channel. Any configuration modifications to a
channel or overall network (e.g. a member leaving or joining) will result
in a new configuration block being appended to the appropriate chain. This
block will contain the contents of the genesis block, plus the delta.

.. _Consensus:
.. _Consenso:

Consenso
--------

Um termo mais amplo abrangendo todo o fluxo transacional, que serve para gerar 
a concordância sobre o pedido e para confirmar a validade do conjunto de 
transações que constituem um bloco.

.. _Consenter-Set:

Consenter set
-------------

In a Raft ordering service, these are the ordering nodes actively participating
in the consensus mechanism on a channel. If other ordering nodes exist on the
system channel, but are not a part of a channel, they are not part of that
channel's consenter set.

.. _Consortium:
.. _Consorcio:

Consórcio
---------

Um consórcio, é uma coleção de organizações que não enviam ordens para rede 
blockchain. Essas são as organizações que formam e fazem parte nos canais e que 
possuem pares. Enquanto uma rede blockchain pode ter vários consórcios, a maioria
das redes blockchain possui um único consórcio. No momento da criação do canal, 
todas as organizações adicionadas ao canal devem fazer parte de um consórcio. No 
entanto, uma organização que não está definida em um consórcio pode ser 
adicionada a um canal existente.

.. _Chaincode-definition:

Chaincode definition
--------------------

A chaincode definition is used by organizations to agree on the parameters of a
chaincode before it can be used on a channel. Each channel member that wants to
use the chaincode to endorse transactions or query the ledger needs to approve
a chaincode definition for their organization. Once enough channel members have
approved a chaincode definition to meet the Lifecycle Endorsement policy (which
is set to a majority of organizations in the channel by default), the chaincode
definition can be committed to the channel. After the definition is committed,
the first invoke of the chaincode (or, if requested, the execution of the Init
function) will start the chaincode on the channel.

.. _Dynamic-Membership:

Dynamic Membership
------------------

Hyperledger Fabric supports the addition/removal of members, peers, and ordering service
nodes, without compromising the operationality of the overall network. Dynamic
membership is critical when business relationships adjust and entities need to
be added/removed for various reasons.

.. _Endorsement:
.. _Endosso:

Endosso
-------

Refere-se ao processo em que os nós de pares específicos executam uma transação 
de um chaincode e retornam uma resposta para proposta ao aplicativo cliente. A 
resposta da proposta inclui a mensagem de resposta da execução do chaincode, 
resultados (conjunto de leituras e gravações) e eventos, além de uma assinatura 
para servir como prova da execução do chaincode do nó. Os aplicativos Chaincode 
possuem políticas de endosso, nas quais os pares endossantes são especificados.

.. _Endorsement-policy:
.. _Politica-de-endosso:

Política de endosso
-------------------

Define os nós pares em um canal que devem executar as transações associadas a um
aplicativo chaincode específico e a combinação necessária de respostas 
(recomendações). Uma política pode exigir que uma transação seja endossada por um
número mínimo de pares, endossado por uma porcentagem mínima de pares ou
endossados por todos os pares atribuídos a um aplicativo chaincode específico. 
As políticas podem ser selecionadas com base na aplicação e no nível desejado de 
resiliência contra mau comportamento (deliberado ou não) dos pares endossantes. 
Uma transação enviada deve satisfazer a política de endosso antes de ser marcada 
como válida por meio da confirmação de pares.

.. _World-State:
.. _Estado-Global:

Estado Global
-------------

.. figure:: ./glossary/glossary.worldstate.png
   :scale: 40 %
   :align: right
   :figwidth: 25 %
   :alt: Estado Atual

   Estado Global, 'W'

Também conhecido como "estado atual", o estado global é um componente do 
:ref:`livro-razão` da HyperLedger Fabric. O estado global representa os valores 
mais recentes para todas as chaves incluídas no log de transações da cadeia. O 
Chaincode executa propostas de transação com base nos dados do estado global 
porque o estado global fornece acesso direto ao valor mais recente dessas chaves, 
em vez de precisar calculá-las percorrendo todo o log de transações. O estado global
muda sempre que o valor de uma chave é alterado (por exemplo, quando a 
propriedade de um carro -- a "chave" -- ​​é transferida de um proprietário para 
outro -- o "valor") ou quando uma nova chave é adicionada (um carro é criado). 
Como resultado, o estado global é crítico para um fluxo de transações, pois o 
estado atual de um par de chave-valor deve ser conhecido antes que possa ser 
alterado. Os pares confirmam os valores mais recentes no estado global do 
livro-razão para cada transação válida incluída em um bloco processado.

.. _Follower:

Follower
--------

In a leader based consensus protocol, such as Raft, these are the nodes which
replicate log entries produced by the leader. In Raft, the followers also receive
"heartbeat" messages from the leader. In the event that the leader stops sending
those message for a configurable amount of time, the followers will initiate a
leader election and one of them will be elected leader.

.. _Genesis-Block:

Genesis Block
-------------

The configuration block that initializes the ordering service, or serves as the
first block on a chain.

.. _Fabric-ca:

Hyperledger Fabric CA
---------------------

Hyperledger Fabric CA is the default Certificate Authority component, which
issues PKI-based certificates to network member organizations and their users.
The CA issues one root certificate (rootCert) to each member and one enrollment
certificate (ECert) to each authorized user.

.. _Init:

Init
----

A method to initialize a chaincode application. All chaincodes need to have an
an Init function. By default, this function is never executed. However you can
use the chaincode definition to request the execution of the Init function in
order to initialize the chaincode.

.. _Install:

Instalação
----------

O processo de colocar um código chaincode no sistema de arquivos do nó.

Instantiate
-----------

The process of starting and initializing a chaincode application on a specific
channel. After instantiation, peers that have the chaincode installed can accept
chaincode invocations.

**NOTE**: *This method i.e. Instantiate was used in the 1.4.x and older versions of the chaincode
lifecycle. For the current procedure used to start a chaincode on a channel with
the new Fabric chaincode lifecycle introduced as part of Fabric v2.0,
see Chaincode-definition_.*

.. _Invoke:
.. _Invocacao:

Invocação
---------

Usado para chamar funções de um chaincode. Um aplicativo cliente chama o chaincode
enviando uma proposta de transação para um nó par. O par executará o código de 
chaincode e retornará uma da proposta de resposta endossada ao aplicativo cliente. 
O aplicativo cliente reunirá as respostas das propostas o suficientes para satisfazer 
uma política de endosso e em seguida, enviará os resultados da transação para 
ordenação, validação e confirmação. O aplicativo cliente pode optar por não enviar
os resultados da transação. Por exemplo, se a chamada apenas consultasse o 
livro-razão, o aplicativo cliente normalmente não enviaria a transação de leitura
apenas, a menos que haja desejo de registrar a leitura no razão para fins de 
auditoria. A chamada inclui, um identificador do canal, a função do chaincode a 
ser chamada e uma matriz de argumentos.

.. _Leader

Leader
------

In a leader based consensus protocol, like Raft, the leader is responsible for
ingesting new log entries, replicating them to follower ordering nodes, and
managing when an entry is considered committed. This is not a special **type**
of orderer. It is only a role that an orderer may have at certain times, and
then not others, as circumstances determine.

.. _Ledger:
.. _Livro-Razao:

Livro-Razão
-----------

.. figure:: ./glossary/glossary.ledger.png
   :scale: 25 %
   :align: right
   :figwidth: 20 %
   :alt: Um Livro-Razão

   Um Livro-Razão, 'L'

Um livro-razão consiste em duas partes distintas, embora relacionadas -- uma 
"blockchain" e o "banco de dados de estados", também conhecido como "estado 
global". Diferente de outros livros, as cadeias de blocos são **imutáveis**, ou 
seja, depois que um bloco é adicionado à cadeia, ele não pode ser alterado. Por 
outro lado, o "estado global" é um banco de dados que contém o valor atual do 
conjunto de pares de chave-valor que foram adicionados, modificados ou excluídos 
pelo conjunto de transações validadas e confirmadas na blockchain.

É útil pensar em um registro livro-razão **lógico** para cada canal da rede. Na 
realidade, cada par em um canal mantém sua própria cópia do livro-razão -- que é 
mantida consistente com a cópia de qualquer outro par através de um processo 
chamado **consenso**. O termo **Tecnologia de Livro-Razão Distribuído** (**DLT**) 
é frequentemente associado a esse tipo de livro-razão -- um que é logicamente 
singular, mas tem muitas cópias idênticas distribuídas em um conjunto de nós da 
rede (os pares e o serviço de ordens).

.. _Log-entry

Log entry
---------

The primary unit of work in a Raft ordering service, log entries are distributed
from the leader orderer to the followers. The full sequence of such entries known
as the "log". The log is considered to be consistent if all members agree on the
entries and their order.

.. _Member:
.. _Membro:

Membro
------

Veja Organização_.

.. _Ordering-Service:
.. _Servico-Ordem:

Ordering Service
----------------

Também conhecido como **ordenador**. Um conjunto definido de nós que ordena as 
transações em um bloco e depois distribui os blocos aos pares conectados para 
validação e confirmação. O serviço de ordens existe independentemente dos 
processos dos nós e das transações de ordenadas no estilo primeiro-a-chegar-primeiro-a-ser-atendido,
para todos os canais da rede. Ele foi projetado para suportar implementações 
conectáveis além do Kafka e do Raft. É uma ligação comum para toda a rede, 
contém o material de identidade criptográfica vinculado a cada Membro_.

.. _No:

Nó
--

Veja Par_.


.. _Anchor-Peer:
.. _No-Ancora:

Nó Âncora
---------

Usado pelo :ref:`protocolo-gossip` para garantir que os pares de diferentes 
organizações se conheçam.

Quando um bloco de configuração que contém alguma atualização sobre os pares âncoras 
é confirmado na rede, os demais nós se conectam ao nós âncoras para obter com 
eles todas as informações dos demais nós pares. Depois que pelo menos um nó 
de cada organização entra em contato com um nó âncora, o nó âncora aprendem sobre 
todos os demais nós do canal. Como a comunicação do protocolo Gossip é constante,
e como os nós sempre pedem que sejam informados sobre a existência de alguém que 
eles desconhecem, uma visão única da associação pode ser estabelecida para um canal.

Por exemplo, vamos supor que temos três organizações --- ``A``, ``B``, ``C`` 
--- no canal e um único ponto de ancoragem --- ``peer0.orgC`` --- definido para 
a organização ``C``. Quando ``peer1.orgA`` (da organização ``A``) entrar em 
contato com ``peer0.orgC``, ele informará ao ``peer0.orgC`` sobre ``peer0.orgA``. 
E quando mais tarde ``peer1.orgB`` entrar em contato com ``peer0.orgC``, o 
último dirá ao primeiro sobre ``peer0.orgB``. Desse ponto em diante, as 
organizações ``A`` e ``B`` começariam a trocar informações de membros 
diretamente sem a ajuda de ``peer0.orgC``.

Como a comunicação entre as organizações depende do protocolo Gossip para 
funcionar, deve haver pelo menos um nó de ancoragem definido na configuração 
do canal. É altamente recomendável que toda organização forneça seu próprio 
conjunto de nós âncora para alta disponibilidade e redundância.

.. _Organization:
.. _Organizacao:

Organização
-----------

=====

.. figure:: ./glossary/glossary.organization.png
   :scale: 25 %
   :align: right
   :figwidth: 20 %
   :alt: Uma Organização

   Uma Organização, 'ORG'

Também conhecidas como "membros", as organizações são convidadas a ingressar na 
rede blockchain por um provedor de rede blockchain. Uma organização ingressa em 
uma rede adicionando seu provedor de serviços de associação (MSP_) à rede. O MSP 
define como outros membros da rede podem verificar se as assinaturas (como aquelas
sobre transações) foram geradas por uma identidade válida, emitida por essa 
organização. Os direitos de acesso específicos das identidades em um MSP são 
regidos por políticas que também são acordadas quando a organização ingressa na 
rede. Uma organização pode ser tão grande quanto uma corporação multinacional ou 
tão pequena quanto um indivíduo. O ponto final da transação de uma organização é 
um Par_. Uma coleção de organizações forma um consórcio. Embora todas as 
organizações em uma rede sejam membros, nem todas as organizações farão parte de 
um consórcio.

.. _Peer:
.. _Par:

Par
---

.. figure:: ./glossary/glossary.peer.png
   :scale: 25 %
   :align: right
   :figwidth: 20 %
   :alt: A Peer

   Um Par, 'P'

Uma entidade de rede que mantém um livro-razão e executa operações em contêineres 
de chaincode de leitura/gravação no livro-razão. Os pares pertencem e são mantidos 
pelos membros.

.. _Leading-Peer:
.. _Par-Lider:

Par Líder
---------

Cada organização_ pode possuir vários pares em cada canal em que se inscreve. Um
ou mais desses pares devem servir como o líder do canal, para se comunicar com o
serviço de ordens da rede em nome da organização. O serviço de ordens entrega 
blocos para os pares líderes em um canal, que os distribuem para outros pares na
mesma organização.

.. _Policy:
.. _Politica:

Política
--------

Políticas são expressões compostas de propriedades das identidades digitais, por 
exemplo: ``Org1.Peer OR Org2.Peer``. Elas são usadas para restringir o acesso 
aos recursos em uma rede blockchain. Por exemplo, elas determinam quem pode ler 
ou gravar em um canal ou quem pode usar uma API específica do chaincode por meio 
de uma ACL_. As políticas podem ser definidas em ``configtx.yaml`` antes de 
inicializar um serviço de ordens ou criar um canal, ou podem ser especificadas 
ao instanciar o chaincode em um canal. Um conjunto padrão de políticas é enviado 
no exemplo ``configtx.yaml``, que será apropriado para a maioria das redes.

.. _glossary-Private-Data:

Private Data
------------

Confidential data that is stored in a private database on each authorized peer,
logically separate from the channel ledger data. Access to this data is
restricted to one or more organizations on a channel via a private data
collection definition. Unauthorized organizations will have a hash of the
private data on the channel ledger as evidence of the transaction data. Also,
for further privacy, hashes of the private data go through the
:ref:`servico`, not the private data itself, so this keeps private data
confidential from Orderer.

.. _glossary-Private-Data-Collection:

Private Data Collection (Collection)
------------------------------------

Used to manage confidential data that two or more organizations on a channel
want to keep private from other organizations on that channel. The collection
definition describes a subset of organizations on a channel entitled to store
a set of private data, which by extension implies that only these organizations
can transact with the private data.

.. _Proposal:
.. _Proposta:

Proposta
--------

Uma solicitação de endosso destinada aos pares específicos em um canal. Cada 
proposta é uma solicitação Init ou Invoke (leitura/gravação).

.. _Gossip-Protocol:
.. _Protocolo-Gossip:

Protocolo Gossip
----------------

O protocolo Gossip de disseminação de dados executa três funções:

1) gerencia a descoberta de pares e associação ao canal;
2) divulga dados do livro-razão entre todos os pares no canal;
3) sincroniza o estado do livro-razão entre todos os pares no canal.

Consulte o tópico :doc:`Gossip <gossip>` para obter mais detalhes.

.. _MSP:

Provedor de Serviço de Associação (MSP)
---------------------------------------

.. figure:: ./glossary/glossary.msp.png
   :scale: 35 %
   :align: right
   :figwidth: 25 %
   :alt: Um MSP

   Um MSP, 'ORG.MSP'

O Provedor de Serviço de Associação (MSP) refere-se a um componente abstrato do 
sistema que fornece credenciais aos clientes e aos nós para eles participarem de 
uma rede Hyperledger Fabric. Os clientes usam essas credenciais para autenticar 
suas transações e os pares usam essas credenciais para autenticar os resultados 
do processamento de transações (endossos). Embora fortemente conectada aos 
componentes de processamento de transações dos sistemas, essa interface visa 
definir componentes de serviços de associação, de forma que implementações 
alternativas possam ser conectadas sem problemas, sem modificar o núcleo dos 
componentes de processamento de transações do sistema.

.. _Query:

Query
-----

A query is a chaincode invocation which reads the ledger current state but does
not write to the ledger. The chaincode function may query certain keys on the ledger,
or may query for a set of keys on the ledger. Since queries do not change ledger state,
the client application will typically not submit these read-only transactions for ordering,
validation, and commit. Although not typical, the client application can choose to
submit the read-only transaction for ordering, validation, and commit, for example if the
client wants auditable proof on the ledger chain that it had knowledge of specific ledger
state at a certain point in time.

.. _Quorum:

Quorum
------

This describes the minimum number of members of the cluster that need to
affirm a proposal so that transactions can be ordered. For every consenter set,
this is a **majority** of nodes. In a cluster with five nodes, three must be
available for there to be a quorum. If a quorum of nodes is unavailable for any
reason, the cluster becomes unavailable for both read and write operations and
no new logs can be committed.

.. _Raft:

Raft
----

New for v1.4.1, Raft is a crash fault tolerant (CFT) ordering service
implementation based on the `etcd library <https://coreos.com/etcd/>`_
of the `Raft protocol <https://raft.github.io/raft.pdf>`_. Raft follows a
"leader and follower" model, where a leader node is elected (per channel) and
its decisions are replicated by the followers. Raft ordering services should
be easier to set up and manage than Kafka-based ordering services, and their
design allows organizations to contribute nodes to a distributed ordering
service.

.. _SDK:

Software Development Kit (SDK)
------------------------------

The Hyperledger Fabric client SDK provides a structured environment of libraries
for developers to write and test chaincode applications. The SDK is fully
configurable and extensible through a standard interface. Components, including
cryptographic algorithms for signatures, logging frameworks and state stores,
are easily swapped in and out of the SDK. The SDK provides APIs for transaction
processing, membership services, node traversal and event handling.

Currently, the two officially supported SDKs are for Node.js and Java, while two
more -- Python and Go -- are not yet official but can still be downloaded
and tested.


.. _Membership-Services:
.. _Servico-Associacao:

Serviço de Associação
---------------------

Membership Services authenticates, authorizes, and manages identities on a
permissioned blockchain network. The membership services code that runs in peers
and orderers both authenticates and authorizes blockchain operations.  It is a
PKI-based implementation of the Membership Services Provider (MSP) abstraction.

.. _Smart-Contract:

Smart Contract
--------------

A smart contract is code -- invoked by a client application external to the
blockchain network -- that manages access and modifications to a set of
key-value pairs in the :ref:`World-State` via :ref:`Transaction`. In Hyperledger Fabric,
smart contracts are packaged as chaincode. Chaincode is installed on peers
and then defined and used on one or more channels.

.. _State-DB:

State Database
--------------

World state data is stored in a state database for efficient reads and queries
from chaincode. Supported databases include levelDB and couchDB.

.. _System-Chain:

System Chain
------------

Contains a configuration block defining the network at a system level. The
system chain lives within the ordering service, and similar to a channel, has
an initial configuration containing information such as: MSP information, policies,
and configuration details.  Any change to the overall network (e.g. a new org
joining or a new ordering node being added) will result in a new configuration block
being added to the system chain.

The system chain can be thought of as the common binding for a channel or group
of channels.  For instance, a collection of financial institutions may form a
consortium (represented through the system chain), and then proceed to create
channels relative to their aligned and varying business agendas.

.. _Transaction:
.. _Transacao:

Transação
---------

.. figure:: ./glossary/glossary.transaction.png
   :scale: 30 %
   :align: right
   :figwidth: 20 %
   :alt: Uma Transação

   Uma Transação, 'T'

As transações são criadas quando um chaincode é chamado a partir de um aplicativo
cliente para ler ou gravar dados do livro-razão. Os aplicativos clientes da 
Fabric submetem propostas de transação para nós endossantes para execução e 
endosso, reúnem as respostas assinadas (endossadas) desses pares endossantes e 
empacotam os resultados e endossos em uma transação que é submetida ao serviço 
de ordens. O serviço de ordens ordena uma solicitação e coloca transações em um 
bloco que é transmitido aos pares que validam e confirmam as transações para o
livro-razão e atualizam o estado global.


.. Licensed under Creative Commons Attribution 4.0 International License
   https://creativecommons.org/licenses/by/4.0/
