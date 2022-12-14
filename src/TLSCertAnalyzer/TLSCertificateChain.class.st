Class {
	#name : #TLSCertificateChain,
	#superclass : #Object,
	#instVars : [
		'source',
		'proxy',
		'rawChain',
		'certs',
		'futureComputation'
	],
	#category : #TLSCertAnalyzer
}

{ #category : #accessing }
TLSCertificateChain class >> load: aFileOrUrl [
	^ self new
		source: aFileOrUrl;
		in: [ :certChain | 
			certChain
				futureComputation: [ certChain analyze ] asAsyncFuture await;
				yourself ]
]

{ #category : #accessing }
TLSCertificateChain >> analyze [
	self parse
]

{ #category : #accessing }
TLSCertificateChain >> certs [
	^ certs ifNil: [ certs := OrderedCollection new ]
]

{ #category : #accessing }
TLSCertificateChain >> certs: anObject [

	certs := anObject
]

{ #category : #accessing }
TLSCertificateChain >> futureComputation [

	^ futureComputation
]

{ #category : #accessing }
TLSCertificateChain >> futureComputation: aPromise [

	futureComputation := aPromise
]

{ #category : #accessing }
TLSCertificateChain >> gtCertDetailsFor: aView [
	^ aView columnedList
		items: self certs;
		column: 'Certificate'
			text: #asString;
		column: 'Valid From' text: #validFrom;
		column: 'Expires On' text: #expiresOn
]

{ #category : #accessing }
TLSCertificateChain >> gtChainFor: aView [
	<gtView>
	^ aView explicit
		title: 'Cert Chain';
		priority: 0;
		stencil: [ BrAsyncWidget new
				matchParent;
				stencil: [ self futureComputation wait.
					(self gtCertDetailsFor: GtPhlowEmptyView new) asElement ] ]
]

{ #category : #accessing }
TLSCertificateChain >> gtSpotterForCertsFor: aSearch [
	<gtSearch>
	| zipFileSystem |
	^ aSearch list
		title: 'Subjects';
		priority: 5;
		items: [ self certs ];
		itemName: #asString;
		itemsLimit: Float infinity;
		filterBySubstring
]

{ #category : #accessing }
TLSCertificateChain >> load [
	^ self source isFile ifTrue: [ self loadFile ] ifFalse: [ self loadHost ]
]

{ #category : #accessing }
TLSCertificateChain >> loadFile [
	self rawChain ifNil: [ self rawChain: self source contents ].
	^ 'cat ' , self source pathString
]

{ #category : #accessing }
TLSCertificateChain >> loadHost [
	| getRawCertChainCommand |
	getRawCertChainCommand := 'echo | openssl s_client -connect '
			, self source host , ':443'
			, (self proxy ifNil: [ '' ] ifNotNil: [ ' -proxy ' , self proxy ])
			, ' -showcerts 2>&1 | sed --quiet "/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p"'.
	self
		rawChain: (GtSubprocessWithInMemoryOutput new
				shellCommand: getRawCertChainCommand;
				runAndWait) stdout.
	^ getRawCertChainCommand
]

{ #category : #accessing }
TLSCertificateChain >> parse [
	| dividerString temp |
	dividerString := '-----END CERTIFICATE-----'.
	temp := Dictionary new.
	self load.
	#('issuer' 'subject' 'text')
		do: [ :each | 
			temp
				at: each
				put: (dividerString split: (self parseCertChainPart: each)) allButLast ].
	temp
		at: 'rawCert'
		put: ((dividerString split: self rawChain)
				select: [ :each | each lines isNotEmpty ]
				thenCollect: [ :each | each , dividerString ]).

	1
		to: (temp at: 'issuer') size
		do: [ :index | 
			self certs
				add: (TLSCertificate new
						certChain: self;
						issuer: (temp at: 'issuer' at: index) trimBoth;
						rawCert: (temp at: 'rawCert' at: index);
						subject: (temp at: 'subject' at: index) trimBoth;
						text: (temp at: 'text' at: index);
						yourself) ]
]

{ #category : #accessing }
TLSCertificateChain >> parseCertChainPart: aString [
	^ (GtSubprocessWithInMemoryOutput new
		shellCommand: self load , ' | while openssl x509 -noout -' , aString
				, ' 2>/dev/null; do : ; echo "-----END CERTIFICATE-----" ; done';
		runAndWait) stdout
]

{ #category : #accessing }
TLSCertificateChain >> printOn: aStream [
	aStream
		nextPutAll: (source isFile ifTrue: [ source pathString ] ifFalse: [ source asString ])
]

{ #category : #accessing }
TLSCertificateChain >> proxy [

	^ proxy
]

{ #category : #accessing }
TLSCertificateChain >> proxy: anObject [

	proxy := anObject
]

{ #category : #accessing }
TLSCertificateChain >> rawChain [

	^ rawChain
]

{ #category : #accessing }
TLSCertificateChain >> rawChain: anObject [

	rawChain := anObject
]

{ #category : #accessing }
TLSCertificateChain >> source [

	^ source
]

{ #category : #accessing }
TLSCertificateChain >> source: aFileOrUrl [

	source := aFileOrUrl
]
