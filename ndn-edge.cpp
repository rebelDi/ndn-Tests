/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/**
 * Copyright (c) 2011-2015  Regents of the University of California.
 *
 * This file is part of ndnSIM. See AUTHORS for complete list of ndnSIM authors and
 * contributors.
 *
 * ndnSIM is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * ndnSIM is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * ndnSIM, e.g., in COPYING.md file.  If not, see <http://www.gnu.org/licenses/>.
 **/

// ndn-simple.cpp

#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/ndnSIM-module.h"


#include <fstream>
#include <iomanip>
#include <iostream>
#include <stdlib.h>

#include <unordered_map>


namespace ns3 {

/**
 * This scenario simulates a very simple network topology:
 *
 *
 *      +----------+     1Mbps      +--------+     1Mbps      +----------+
 *      | consumer | <------------> | router | <------------> | producer |
 *      +----------+         10ms   +--------+          10ms  +----------+
 *
 *
 * Consumer requests data from producer with frequency 10 interests per second
 * (interests contain constantly increasing sequence number).
 *
 * For every received interest, producer replies with a data packet, containing
 * 1024 bytes of virtual payload.
 *
 * To run scenario and see what is happening, use the following command:
 *
 *     NS_LOG=ndn.Consumer:ndn.Producer ./waf --run=ndn-simple
 */

void SentInterestCallback( uint32_t, shared_ptr<const ndn::Interest> );

void SentInterestPECCallback( uint32_t, shared_ptr<const ndn::Interest> );

void BaseStationCallback( uint32_t );

void DisStartCallback(uint32_t, shared_ptr<const ndn::Interest>);
void ReceivedDataCallback( uint32_t, shared_ptr<const ndn::Data>, int );

void ReceivedInterestCallback( uint32_t, shared_ptr<const ndn::Interest> );

void ReceivedDataPECCallback( uint32_t, shared_ptr<const ndn::Data>);

void ServerChoiceCallback( uint32_t nodeid, std::string serverChoice, int serverUtil, std::string ser);

void ServerUpdateCallback( uint32_t nodeid, std::string server, int serverUtil);
std::vector<std::string> SplitString(std::string strLine);


std::ofstream tracefile;
std::ofstream tracefileInput;
std::ofstream tracefile1;


int
main(int argc, char* argv[])
{
  // setting default parameters for PointToPoint links and channels
  //Config::SetDefault("ns3::PointToPointNetDevice::DataRate", StringValue("1Mbps"));
  //Config::SetDefault("ns3::PointToPointChannel::Delay", StringValue("10ms"));
  Config::SetDefault("ns3::QueueBase::MaxSize", StringValue("20p"));

  int run = 0;
  bool proactive = 1;
  std::string PECChange = "1.5";
  double userRequest = 1;
  double discovery = 1;
  // Read optional command-line parameters (e.g., enable visualizer with ./waf --run=<> --visualize
  CommandLine cmd;
  cmd.AddValue("Run", "Run", run);
  cmd.AddValue("Proactive", "Proactive", proactive);
  cmd.AddValue("PECChange", "PECChange", PECChange);
  cmd.AddValue("UserRequest", "UserRequest", userRequest);
  cmd.AddValue("Discovery", "Discovery", discovery);
  cmd.Parse(argc, argv);

  srand( run );
  PointToPointHelper p2p;

  ndn::AppHelper consumerHelper("ns3::ndn::IntelConsumer");
  ndn::AppHelper producerHelper("ns3::ndn::Producer");
  ndn::AppHelper serverHelper("ns3::ndn::PECServer");
  ndn::AppHelper baseStationHelper("ns3::ndn::BaseStation");

  ndn::GlobalRoutingHelper ndnGlobalRoutingHelper;


  int servercount = 0;
  int basecount = 0;
  ifstream configFile ( "src/ndnSIM/examples/topologies/topo.txt", std::ios::in );	// Topology file
  std::string strLine, strcallback;
  bool gettingNodeCount = false, buildingNetworkTopo = false, assignServers = false;
  bool assignBases = false, assignClients = false, assignPECs = false;
  NodeContainer nodes;
  int nodeCount = 0;
  std::vector<std::string> netParams;


	if ( configFile.is_open() ) {

		while ( std::getline( configFile, strLine ) ) {

			// Determine what operation is ongoing while reading the config file
			if( strLine.substr( 0,7 ) == "BEG_000" ) { gettingNodeCount = true; continue; } 
			if( strLine.substr( 0,7 ) == "END_000" ) {
				// Create nodes
				gettingNodeCount = false;
				nodes.Create( nodeCount );
				continue; 
			}
			if( strLine.substr( 0,7 ) == "BEG_001" ) { buildingNetworkTopo = true; continue; }
			if( strLine.substr( 0,7 ) == "END_001" ) { 
                                buildingNetworkTopo = false;
				ndn::StackHelper ndnHelper; 
				ndnHelper.InstallAll();
				ndnGlobalRoutingHelper.Install( nodes );
  				
				continue; 
                        }
			if( strLine.substr( 0,7 ) == "BEG_002" ) { assignServers = true; continue; }
			if( strLine.substr( 0,7 ) == "END_002" ) { assignServers = false; continue; }
			if( strLine.substr( 0,7 ) == "BEG_003" ) { assignBases = true; continue; }
			if( strLine.substr( 0,7 ) == "END_003" ) { assignBases = false; continue; }
			if( strLine.substr( 0,7 ) == "BEG_004" ) { assignClients = true; continue; }
			if( strLine.substr( 0,7 ) == "END_004" ) { assignClients = false; continue;}
			if( strLine.substr( 0,7 ) == "BEG_005" ) { assignPECs = true; continue; }
			if( strLine.substr( 0,7 ) == "END_005" ) { assignPECs = false; continue; }


			if ( gettingNodeCount == true ) {

				// Getting number of nodes to create
				netParams = SplitString( strLine );
				nodeCount = stoi( netParams[0] );

			} else if ( buildingNetworkTopo == true ) {

				// Building network topology
				netParams = SplitString( strLine );
				p2p.SetDeviceAttribute( "DataRate", StringValue( netParams[2] ) );
				p2p.SetChannelAttribute( "Delay", StringValue( netParams[3] ) );
				p2p.Install( nodes.Get( std::stoi( netParams[0] ) ), nodes.Get( std::stoi( netParams[1] ) ) );

			} else if ( assignServers == true ) {
				int scount = 2;
				std::string ser_list = "";
				std::vector<int> services{1, 2, 3};
				for (int i = 0; i < scount; i++){
					int choice = rand()%services.size();
					ser_list += std::to_string(services[choice]) + " ";
					services.erase(services.begin()+choice);
				}

                                netParams = SplitString( strLine );
  			     	serverHelper.SetPrefix("/prefix/server"+std::to_string(servercount));
			     	serverHelper.SetAttribute("UpdatePrefix",StringValue("/prefix/update/server/"+std::to_string(servercount)));
	 	  	     	serverHelper.SetAttribute("Frequency", StringValue("1")); // update base station every second
			     	serverHelper.SetAttribute( "PayloadSize", StringValue( "200" ) );
			     	serverHelper.SetAttribute( "RetransmitPackets", IntegerValue( 0 ) );
		  	     	serverHelper.SetAttribute( "Offset", IntegerValue( 0 ) );
			     	serverHelper.SetAttribute( "LifeTime", StringValue( "10s" ) );
				serverHelper.SetAttribute("UtilMin", IntegerValue(10));
				serverHelper.SetAttribute("UtilRange", IntegerValue(10));
				serverHelper.SetAttribute("UtilRise", IntegerValue(5));
  				serverHelper.SetAttribute("UtilRiseRange", IntegerValue(5));
				serverHelper.SetAttribute("Services", StringValue(ser_list));

		 	     	serverHelper.Install(nodes.Get(std::stoi( netParams[0] ))); 

			     	ndnGlobalRoutingHelper.AddOrigin("prefix", nodes.Get(std::stoi( netParams[0] )));
			     	ndnGlobalRoutingHelper.AddOrigin("prefix/compute/server"+std::to_string(servercount), nodes.Get(std::stoi( netParams[0] )));
                                ndnGlobalRoutingHelper.AddOrigin("prefix/service/server"+std::to_string(servercount), nodes.Get(std::stoi( netParams[0] )));
 
                             	servercount++;
 				strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/ServerUpdate";
  				Config::ConnectWithoutContext( strcallback, MakeCallback( & ServerUpdateCallback ) );
                                strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/SentInterest";
                                Config::ConnectWithoutContext( strcallback, MakeCallback( &SentInterestPECCallback ) );
                                strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/ReceivedData";
                                Config::ConnectWithoutContext( strcallback, MakeCallback( & ReceivedDataPECCallback ) );



			} else if ( assignBases == true ) {

				netParams = SplitString( strLine );
				baseStationHelper.SetPrefix("/prefix");
				baseStationHelper.SetAttribute("PayloadSize", StringValue("1024"));
			     	baseStationHelper.SetAttribute("UpdatePrefix",StringValue("/prefix/baseQuery/"+netParams[0]));
			     	baseStationHelper.SetAttribute("Proactive",IntegerValue( proactive ));
				baseStationHelper.SetAttribute( "Frequency", StringValue( std::to_string(discovery) ) );
				baseStationHelper.Install(nodes.Get(std::stoi( netParams[0] ))); // last node
                                ndnGlobalRoutingHelper.AddOrigin("prefix", nodes.Get(std::stoi( netParams[0])));
				//ndnGlobalRoutingHelper.AddOrigin("prefix/service", nodes.Get(std::stoi( netParams[0])));
				
                                strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/SentInterest";
                                Config::ConnectWithoutContext( strcallback, MakeCallback( &DisStartCallback ) );
                                strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/Overhead";
                                Config::ConnectWithoutContext( strcallback, MakeCallback( &BaseStationCallback ) );
				


			} else if ( assignClients == true ) {


				char temp[10];
                                sprintf(temp, "%d", (rand()%3)+1);
				netParams = SplitString( strLine );
				consumerHelper.SetPrefix("/prefix");
				consumerHelper.SetAttribute("Frequency", StringValue(std::to_string(userRequest))); // 10 interests a second
				consumerHelper.SetAttribute("Service", StringValue(temp));
				consumerHelper.SetAttribute( "PayloadSize", StringValue( "200" ) );
				consumerHelper.SetAttribute( "RetransmitPackets", IntegerValue( 0 ) );
				consumerHelper.SetAttribute( "Offset", IntegerValue( 0 ) );
				consumerHelper.SetAttribute( "LifeTime", StringValue( "10s" ) );
           		  	consumerHelper.SetAttribute( "NodeID", StringValue( netParams[0] ) );
				auto app = consumerHelper.Install(nodes.Get(std::stoi( netParams[0])));      // first node
				app.Start(Seconds(0.2));

  				producerHelper.SetPrefix("/prefix/input/" + netParams[0]);
  				producerHelper.SetAttribute("PayloadSize", StringValue("1024"));
  				producerHelper.Install(nodes.Get(std::stoi( netParams[0]))); // last node
                                ndnGlobalRoutingHelper.AddOrigin("prefix/input/"+netParams[0], nodes.Get(std::stoi( netParams[0])));

  				ndn::StrategyChoiceHelper::Install(nodes.Get( std::stoi( netParams[0]) ),"/prefix/service", "/localhost/nfd/strategy/intel");

  				std::string strcallback;
                                 std::string n = netParams[0];
  				strcallback = "/NodeList/"+n+"/ApplicationList/*/SentInterest";
  				Config::ConnectWithoutContext( strcallback, MakeCallback( &SentInterestCallback ) );
  				strcallback = "/NodeList/"+n+"/ApplicationList/*/ReceivedData";
  				Config::ConnectWithoutContext( strcallback, MakeCallback( & ReceivedDataCallback ) );
  				strcallback = "/NodeList/"+n+"/ApplicationList/*/ServerChoice";
  				Config::ConnectWithoutContext( strcallback, MakeCallback( & ServerChoiceCallback ) );


				
			} else if ( assignPECs == true ) {
				int scount = 1;
                                std::string ser_list = "";
                                std::vector<int> services{1, 2, 3};
                                for (int i = 0; i < scount; i++){
                                        int choice = rand()%services.size();
                                        ser_list += std::to_string(services[choice]) + " ";
                                        services.erase(services.begin()+choice);
                                }

				netParams = SplitString( strLine );
			     	serverHelper.SetPrefix("/prefix/PECserver"+std::to_string(servercount));
			     	serverHelper.SetAttribute("UpdatePrefix",StringValue("/prefix/update/PECserver/"+std::to_string(servercount)));
	 	  	     	serverHelper.SetAttribute("Frequency", StringValue("1")); // update base station every second
			     	serverHelper.SetAttribute( "PayloadSize", StringValue( "200" ) );
			     	serverHelper.SetAttribute( "RetransmitPackets", IntegerValue( 0 ) );
		  	     	serverHelper.SetAttribute( "Offset", IntegerValue( 0 ) );
			     	serverHelper.SetAttribute( "LifeTime", StringValue( "10s" ) );
				serverHelper.SetAttribute("UtilMin", IntegerValue(20));
				serverHelper.SetAttribute("UtilRange", IntegerValue(20));
				serverHelper.SetAttribute("UtilRise", IntegerValue(15));
  				serverHelper.SetAttribute("UtilRiseRange", IntegerValue(10));
				serverHelper.SetAttribute("Services", StringValue(ser_list));
                                serverHelper.SetAttribute("StatChangeFreq", StringValue(PECChange));
                                serverHelper.SetAttribute("ComRate", DoubleValue(1.5));

                                serverHelper.Install(nodes.Get(std::stoi( netParams[0] )));

			     	ndnGlobalRoutingHelper.AddOrigin("prefix/baseQuery", nodes.Get(std::stoi( netParams[0] )));
			     	ndnGlobalRoutingHelper.AddOrigin("prefix", nodes.Get(std::stoi( netParams[0] )));
			     	ndnGlobalRoutingHelper.AddOrigin("prefix/compute/PECserver"+std::to_string(servercount), nodes.Get(std::stoi( netParams[0] ))); 
                              	servercount++;

 				strcallback = "/NodeList/"+netParams[0]+"/ApplicationList/*/ServerUpdate";
  				Config::ConnectWithoutContext( strcallback, MakeCallback( & ServerUpdateCallback ) );


			} else {
				//std::cout << "reading something else " << strLine << std::endl;
			}	
		} // end while
	} else {
		std::cout << "Cannot open configuration file!!!" << std::endl;
		exit( 1 );
	}

	configFile.close();

  ndn::StrategyChoiceHelper::InstallAll( "prefix/update", "/localhost/nfd/strategy/multicast" );
  ndn::StrategyChoiceHelper::InstallAll( "prefix/baseQuery", "/localhost/nfd/strategy/multicast" );

  ndn::GlobalRoutingHelper::CalculateAllPossibleRoutes();

  //Open trace file for writing
  char trace[100];
  if(proactive)
  	sprintf( trace, "ndn-proactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );
  else
  	sprintf( trace, "ndn-reactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );

  tracefile.open( trace, std::ios::out );
  tracefile << "nodeid,event,name,time" << std::endl;
  if(proactive)
	  sprintf( trace, "choice-proactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );
  else
	  sprintf( trace, "choice-reactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );

  tracefile1.open( trace, std::ios::out );
  tracefile1 << "nodeid,event,server,util,time,list" << std::endl;

  if(proactive)
          sprintf( trace, "input-proactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );
  else
          sprintf( trace, "input-reactive-%lf-%lf-%lf-run%d.csv", std::stod(PECChange), discovery, userRequest, run );

  tracefileInput.open( trace, std::ios::out );
  tracefileInput << "nodeid,event,name,time" << std::endl;


  Simulator::Stop(Seconds(1000));

  Simulator::Run();
  Simulator::Destroy();

  return 0;
}


void SentInterestCallback( uint32_t nodeid, shared_ptr<const ndn::Interest> interest){
  tracefile << nodeid << ",sent," << interest->getName() << "," << std::fixed << setprecision( 9 ) << 
	  ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}

void SentInterestPECCallback( uint32_t nodeid, shared_ptr<const ndn::Interest> interest){
  tracefileInput << nodeid << ",sent," << interest->getName() << "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}


void BaseStationCallback( uint32_t nodeid){
  tracefile << nodeid << ",over," << "__"<< "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}

void DisStartCallback( uint32_t nodeid, shared_ptr<const ndn::Interest>){
  tracefile << nodeid << ",dis," << "__"<< "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}


void ReceivedDataCallback( uint32_t nodeid, shared_ptr<const ndn::Data> data, int offset){
  
	ndn::Name traceName = data->getName().getSubName(0,1);
  traceName.append("service");
  traceName.append(std::to_string(nodeid));
  uint32_t seq = data->getName().at( -1 ).toSequenceNumber();
  traceName.appendSequenceNumber(seq-1);

  tracefile << nodeid << ",received," << traceName << "," << std::fixed << setprecision( 9 ) << 
	  ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}

void  ReceivedDataPECCallback( uint32_t nodeid, shared_ptr<const ndn::Data> data){
  tracefileInput << nodeid << ",received," << data->getName() << "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}


void ReceivedInterestCallback( uint32_t nodeid, shared_ptr<const ndn::Interest> interest ){
  tracefile << nodeid << ",compute," << interest->getName() << "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}

void ServerChoiceCallback( uint32_t nodeid, std::string serverChoice, int serverUtil, std::string ser){
  tracefile1 << nodeid << ",choice," << serverChoice << "," << serverUtil << "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << "," << ser << std::endl;
}

void ServerUpdateCallback( uint32_t nodeid, std::string server, int serverUtil){
  tracefile1 << nodeid << ",update," << server << "," << serverUtil << "," << std::fixed << setprecision( 9 ) <<
          ( Simulator::Now().GetNanoSeconds() )/1000000000.0 << std::endl;
}


//Split a string delimited by space
std::vector<std::string> SplitString(std::string strLine) {
        std::string str = strLine;
        std::vector<std::string> result;
        std::istringstream isstr(str);
        for(std::string str; isstr >> str; )
                result.push_back(str);

        return result;
}



} // namespace ns3

int
main(int argc, char* argv[])
{
  return ns3::main(argc, argv);
}