module TransmissionHelper
  def stub_transmission_rpc_request
    result = OpenStruct.new(percentDone: 1)
    allow(Transmission::Model::Torrent).to receive(:find).and_return(result)
  end
end
