��          �               �  _  �     �  �   �     �     �              6  "   M      p  Z   �  S   �  �   @     >  �   E  �   �  n   �  �    	     �	  a   �	  q   
     �
  �  �
  _  -     �  �   �     v     �    �     �     �  "   �        Z   1  S   �  �   �     �  �   �  �   ~  n   1  �   �     S  a   Y  q   �     -   <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. Configuration Construct an organization definition based on the parameters such as MSPDir from configtx.yaml and print it as JSON to the screen. (This output is useful for channel reconfiguration workflows, such as adding a member). Inspect a channel creation tx Inspect a genesis block Output a channel configuration update transaction anchor_peer_tx.pb  based on the anchor peers defined for Org1 and channel profile SampleSingleMSPChannelV1_1 in configtx.yaml. Transaction will set anchor peers for Org1 if no anchor peers have been set on the channel. Output a channel creation tx Output a genesis block Output anchor peer tx (deprecated) Print an organization definition Print the contents of a channel creation tx named create_chan_tx.pb to the screen as JSON. Print the contents of a genesis block named genesis_block.pb to the screen as JSON. Refer to the sample configtx.yaml shipped with Fabric for all possible configuration options.  You may find this file in the config directory of the release artifacts tar, or you may find it under the sampleconfig folder if you are building from source. Syntax The -outputAnchorPeersUpdate output flag has been deprecated. To set anchor peers on the channel, use configtxlator to update the channel configuration. The configtxgen command allows users to create and inspect channel config related artifacts.  The content of the generated artifacts is dictated by the contents of configtx.yaml. The configtxgen tool has no sub-commands, but supports flags which can be set to accomplish a number of tasks. The configtxgen tool's output is largely controlled by the content of configtx.yaml.  This file is searched for at FABRIC_CFG_PATH and must be present for configtxgen to operate. Usage Write a channel creation transaction to create_chan_tx.pb for profile SampleSingleMSPChannelV1_1. Write a genesis block to genesis_block.pb for channel orderer-system-channel for profile SampleSingleMSPRaftV1_1. configtxgen Project-Id-Version: hyperledger-fabricdocs master
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2020-05-24 19:11-0300
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: pt_BR
Language-Team: pt_BR <LL@li.org>
Plural-Forms: nplurals=2; plural=(n > 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.6.0
 <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. Configuration Construct an organization definition based on the parameters such as MSPDir from configtx.yaml and print it as JSON to the screen. (This output is useful for channel reconfiguration workflows, such as adding a member). Inspect a channel creation tx Inspect a genesis block Output a channel configuration update transaction anchor_peer_tx.pb  based on the anchor peers defined for Org1 and channel profile SampleSingleMSPChannelV1_1 in configtx.yaml. Transaction will set anchor peers for Org1 if no anchor peers have been set on the channel. Output a channel creation tx Output a genesis block Output anchor peer tx (deprecated) Print an organization definition Print the contents of a channel creation tx named create_chan_tx.pb to the screen as JSON. Print the contents of a genesis block named genesis_block.pb to the screen as JSON. Refer to the sample configtx.yaml shipped with Fabric for all possible configuration options.  You may find this file in the config directory of the release artifacts tar, or you may find it under the sampleconfig folder if you are building from source. Syntax The -outputAnchorPeersUpdate output flag has been deprecated. To set anchor peers on the channel, use configtxlator to update the channel configuration. The configtxgen command allows users to create and inspect channel config related artifacts.  The content of the generated artifacts is dictated by the contents of configtx.yaml. The configtxgen tool has no sub-commands, but supports flags which can be set to accomplish a number of tasks. The configtxgen tool's output is largely controlled by the content of configtx.yaml.  This file is searched for at FABRIC_CFG_PATH and must be present for configtxgen to operate. Usage Write a channel creation transaction to create_chan_tx.pb for profile SampleSingleMSPChannelV1_1. Write a genesis block to genesis_block.pb for channel orderer-system-channel for profile SampleSingleMSPRaftV1_1. configtxgen 