# Copyright (C) 2017 Red Hat Inc.
#
# Author: Ricardo Noriega <rnoriega@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'neutron::agents::bagpipe' do

  let :params do
    {
      :my_as                  => 64512,
      :api_port               => 8082,
      :dataplane_driver_ipvpn => 'ovs',
      :enabled                => true,
      :enable_rtc             => true,
      :manage_service         => true,
      :mpls_interface         => '*gre*',
      :ovs_bridge             => 'br-mpls',
      :package_ensure         => 'present',
      :peers                  => '192.168.0.101',
      :proxy_arp              => false,
      :purge_config           => false,
      :local_address          => '127.0.0.1'
    }
  end

  let :default_params do
    {}
  end

  shared_examples 'neutron bgpvpn bagpipe agent' do
    let :p do
      default_params.merge(params)
    end

    it 'passes purge to resource' do
      should contain_resources('neutron_bgpvpn_bagpipe_config').with({
        :purge => false
      })
    end

    it 'installs bgpvpn bagpipe package' do
      should contain_package('openstack-bagpipe-bgp').with(
        :ensure => p[:package_ensure],
        :name   => platform_params[:bagpipe_bgp_package],
      )
    end

    it 'configures bgp.conf' do
      should contain_neutron_bgpvpn_bagpipe_config('api/port').with_value(p[:api_port])
      should contain_neutron_bgpvpn_bagpipe_config('bgp/local_address').with_value(p[:local_address])
      should contain_neutron_bgpvpn_bagpipe_config('bgp/peers').with_value(p[:peers])
      should contain_neutron_bgpvpn_bagpipe_config('bgp/my_as').with_value(p[:my_as])
      should contain_neutron_bgpvpn_bagpipe_config('bgp/enable_rtc').with_value(p[:enable_rtc])
      should contain_neutron_bgpvpn_bagpipe_config('dataplane_driver_ipvpn/dataplane_driver').with_value(p[:dataplane_driver_ipvpn])
      should contain_neutron_bgpvpn_bagpipe_config('dataplane_driver_ipvpn/ovs_bridge').with_value(p[:ovs_bridge])
      should contain_neutron_bgpvpn_bagpipe_config('dataplane_driver_ipvpn/proxy_arp').with_value(p[:proxy_arp])
      should contain_neutron_bgpvpn_bagpipe_config('dataplane_driver_ipvpn/mpls_interface').with_value(p[:mpls_interface])
    end

    it 'bagpipe service running' do
      should contain_service('bagpipe-bgp').with_ensure('running')
    end

    context 'with multiple peers' do
      before :each do
        params.merge!(
          { :peers => ['peer1', 'peer2'] }
        )
      end

      it 'configures multiple peers in bgp.conf' do
        should contain_neutron_bgpvpn_bagpipe_config(
          'bgp/peers'
        ).with_value(p[:peers].join(','))
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'RedHat'
          { :bagpipe_bgp_package => 'openstack-bagpipe-bgp' }
        when 'Debian'
          { :bagpipe_bgp_package => 'openstack-bagpipe-bgp' }
        end
      end

      it_behaves_like 'neutron bgpvpn bagpipe agent'
    end
  end
end
