function Invoke-AsBuiltReport.VMware.NSX-T {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.NSX-T
    #>

    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options
    # Used to set values to TitleCase where required
    $TextInfo = (Get-Culture).TextInfo

    #region Script Body
    #---------------------------------------------------------------------------------------------#
    #                                         SCRIPT BODY                                         #
    #---------------------------------------------------------------------------------------------#
    # Connect to NSX-T Manager using supplied credentials
    foreach ($NsxManager in $Target) {
        try {
            Write-PScriboMessage "Connecting to NSX-T Manager '$NsxManager'."
            Connect-NsxtServer -Server $nsxManager -Credential $Credential -ErrorAction Stop
        } catch {
            Write-Error "Unable to connect to NSX-T Manager '$NsxManager'"
            Write-Error $_
            Continue
        }

        # Report index:
        #System
        #    NSX-T Manager
        #    Controllers
        #    Compute Managers
        #    Edge Clusters
        #    Edge Nodes
        #    Transport Nodes
        #    Transport Zones
        #Networking
        #    Logical switches
        #    Gateway/Routers
        #    Segments # TODO
        #    Routing
        #Security
        #    EW firewall
        #    Gateway firewall (NS) # TODO
        #    Extras (URL, IDS, Introspection) # TODO
        #Inventory
        #    Services (NAT, LB, VPN, DHCP, DNS) # TODO
        #    IP address Pools


        Section -Style Heading1 'NSX-T System' {

            try {
                Section -Style Heading2 'NSX-T Manager Details' {
                    Paragraph 'The following section provides a summary of the Manager Details.'
                    BlankLine
                    Get-NSXTManager | Table -Name 'NSX-T Manager Details' -List
                }
            } catch {
                Write-Error $_
            }

            try {
                Section -Style Heading2 'NSX-T Controllers' {
                    Paragraph 'The following section provides a summary of the configured Compute Managers.'
                    BlankLine
                    Get-NSXTController  | Table -Name 'NSX-T Controllers' -List
                }
            } catch {
                Write-Error $_
            }

            try {
                Section -Style Heading2 'NSX-T Compute Managers' {
                    Paragraph 'The following section provides a summary of the configured Compute Managers.'
                    BlankLine
                    Get-NSXTComputeManager | Table -Name 'Compute Managers' -List
                }
            } catch {
                Write-Error $_
            }

            try {
                $EdgeClusters = Get-NSXTEdgeCluster
                if ($EdgeClusters) {
                    Section -Style Heading2 'NSX-T Edge Clusters' {
                        BlankLine
                        $EdgeClusters  | Table -Name 'NSX-T Edge Clusters' -List
                    }
                }
            } catch {
                Write-Error $_
            }


            try {
                Section -Style Heading2 'NSX-T Edge Nodes' {
                    Paragraph 'The following section provides a summary of the configured Edge Nodes.'
                    BlankLine
                    Get-NSXTFabricNode -Edge | Table -Name 'NSX-T Edge Nodes' -List
                }
            } catch {
                Write-Error $_
            }


            try {
                Section -Style Heading2 'NSX-T Transport Nodes' {
                    Paragraph 'The following section provides a summary of the configured Transport Nodes.'
                    BlankLine
                    Get-NSXTTransportNode | Table -Name 'NSX-T Transport Nodes' -List
                }
            } catch {
                Write-Error $_
            }

            try {
                Section -Style Heading2 'NSX-T Transport Zones' {
                    Paragraph 'The following section provides a summary of the configured Transport Zones.'
                    BlankLine
                    Get-NSXTTransportZone  | Table -Name 'NSX-T Transport Zones' -List
                }
            } catch {
                Write-Error $_
            }

        } # end Section -Style Heading1 'NSX-T System' {


        Section -Style Heading1 'NSX-T Networking' {
            try {
                Section -Style Heading2 'NSX-T Logical Switches' {
                    Paragraph 'The following section provides a summary of the configured Logical Switches.'
                    BlankLine
                    Get-NSXTLogicalSwitch  | Table -Name 'NSX-T Logical Switches' -List
                }
            } catch {
                Write-Error $_
            }

            try {
                $LR = Get-NSXTLogicalRouter
                if ($LR) {
                    Section -Style Heading2 'NSX-T Logical Routers' {
                        Paragraph 'The following section provides a summary of the configured Compute Managers.'
                        BlankLine
                        $LR | Table -Name 'NSX-T Logical Routers' -List
                    }
                }
            } catch {
                Write-Error $_
            }

            try {
                Section -Style Heading2 'NSX-T Network Routes' {
                    Paragraph 'The following section provides a summary of the configured Network Routes.'
                    BlankLine
                    Get-NSXTNetworkRoutes  | Table -Name 'NSX-T Network Routes' -List
                }
            } catch {
                Write-Error $_
            }

        } # end Section -Style Heading1 'NSX-T Networking' {

        Section -Style Heading1 'NSX-T Security' {

            try {
                Section -Style Heading2 'NSX-T Distributed Firewall Rules' {
                    Paragraph 'The following section provides a summary of the configured Compute Managers.'
                    BlankLine
                    Get-NSXTFirewallRule  | Table -Name 'NSX-T Distributed Firewall Rules' -List
                }
            } catch {
                Write-Error $_
            }


        } # end Section -Style Heading1 'NSX-T Security' {

        Section -Style Heading1 'NSX-T Inventory' {

            try {
                $IPAMBlock = Get-NSXTIPAMIPBlock
                if ($IPAMBlock) {
                    Section -Style Heading2 'NSX-T IPAM Block' {
                        Paragraph 'The following section provides a summary of the configured Compute Managers.'
                        BlankLine
                        $IPAMBlock | Table -Name 'NSX-T IPAM Block' -List
                    }
                }
            } catch {
                Write-Error $_
            }

            try {
                Section -Style Heading2 'NSX-T IP Pool' {
                    Paragraph 'The following section provides a summary of the configured Compute Managers.'
                    BlankLine
                    Get-NSXTIPPool  | Table -Name 'NSX-T IP Pool' -List
                }
            } catch {
                Write-Error $_
            }


        } # end Section -Style Heading1 'NSX-T Inventory' {




        # Section -Style Heading2 'BGP Neighbours' {
        #     Paragraph 'The following section provides a summary of the configured Compute Managers.'
        #     BlankLine
        #     Get-NSXTBGPNeighbors  | Table -Name 'BGP Neighbours' -List
        # }




        Disconnect-NsxtServer -Confirm:$false
    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function