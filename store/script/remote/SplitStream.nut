streams <- {};

function ProcessSplitStream(stream) {
	// Read metadata from the stream
	local sequenceNumber = stream.ReadInt(); // SequenceNumber (4 bytes)
	local chunkID = stream.ReadInt(); // ChunkID (4 bytes)
	local totalChunks = stream.ReadInt(); // TotalChunks (4 bytes)
	local payloadLength = stream.ReadByte() + 256 * stream.ReadByte(); // PayloadLength (2 bytes)

	if (stream.Error)
		throw ("Stream length insufficient");

	// Ensure a global entry for this sequence number
	if (!::streams.rawin(sequenceNumber)) {

		::streams.rawset(sequenceNumber, {
			totalChunks = totalChunks,
			chunks = {}, // Store chunks by ChunkID
			receivedCount = 0 // Track how many chunks have been received
		});
	}

	local streamData = ::streams[sequenceNumber];

	// Validate ChunkID and TotalChunks
	if (chunkID >= totalChunks) {
		throw "Invalid ChunkID!";
	}

	// Check if this chunk has already been received
	if (!streamData.chunks.rawin(chunkID)) {
		// Read the payload
		local payload = [];
		for (local i = 0; i < payloadLength; i++) {
			payload.push(stream.ReadByte());
		}

		if (stream.Error)
			throw ("Stream Error: Reading after end of stream");

		// Store the chunk payload and update received count
		streamData.chunks.rawset(chunkID, payload);
		streamData.receivedCount++;
	}

	// Check if the stream is fully received
	if (streamData.receivedCount == streamData.totalChunks) {
		// Reconstruct the stream
		local fullStream = ReconstructStream(streamData.chunks, totalChunks);

		// Clean up the global table entry
		::streams.rawdelete(sequenceNumber);

		// Handle the reconstructed stream
		HandleReconstructedStream(sequenceNumber, fullStream);
	}
}
function ReconstructStream(chunks, totalChunks) {
	local fullStream = [];
	for (local i = 0; i < totalChunks; i++) {
		if (!chunks[i]) {
			throw "Missing chunk: " + i;
		}
		fullStream.extend(chunks[i]);
	}
	return fullStream;
}
function HandleReconstructedStream(sequenceNumber, fullStream) {
	// print("Stream " + sequenceNumber + " fully reconstructed. Length: " + fullStream.len());
	// Add your handling logic here, e.g., process the fullStream data
	local stream = ::betterblob(fullStream.len());
	//Make the blob
	for (local i = 0; i < fullStream.len(); i++)
		stream[i] = fullStream[i]
	//Reset read position
	stream.seek(0); //beginning of the stream
	//We ignore the sequenceNumber
	//Now call Server::ServerData
	::Server.ServerData(stream); //betterblob has all functions of Stream class.
}