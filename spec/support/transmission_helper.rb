module TransmissionHelper
  def stub_transmission_rpc_request(id: rand(1..100), name: SecureRandom.uuid)
    result = OpenStruct.new(id: id, name: name, finished?: true)
    klass = Transmission::Model::Torrent
    allow(klass).to receive(:find).and_return(result)
    allow(klass).to receive(:add).and_return(result)
  end
end
