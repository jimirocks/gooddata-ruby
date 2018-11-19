# Copyright (c) 2010-2018 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'gooddata'

describe GoodData::Bricks::HelpBrick do
  before(:all) do
    @rest_client = ConnectionHelper.create_default_connection
    @project = ProjectHelper.get_default_project client: @rest_client
    @options = { project: @project, client: @rest_client }

    image_tag = ENV['LCM_BRICKS_IMAGE_TAG'] || 'M3'
    GoodData.logger.debug("Using #{image_tag} ...")
    @name = "lcm-brick[#{image_tag}]-help"
  end

  after(:all) do
    @component.delete if @component
    @rest_client.disconnect
  end

  it 'deploys and run' do
    brick_component_data = {
      name: @name,
      type: 'LCM',
      component: {
        name: @name,
        version: '3'
      }
    }
    @component = GoodData::Process.deploy_component brick_component_data, client: @rest_client, project: @project
    expect(@component.name).to eq @name
    expect(@component.type).to eq :lcm

    ## TODO run the brick using schedule and expect the result
  end
end
