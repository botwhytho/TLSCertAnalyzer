Class {
	#name : #TLSCertificate,
	#superclass : #Object,
	#instVars : [
		'issuer',
		'subject',
		'text',
		'rawCert'
	],
	#category : #TLSCertAnalyzer
}

{ #category : #accessing }
TLSCertificate >> issuer [

	^ issuer
]

{ #category : #accessing }
TLSCertificate >> issuer: anObject [

	issuer := anObject
]

{ #category : #accessing }
TLSCertificate >> printOn: aStream [
	aStream
		nextPutAll: ('=' split: (self subject copyReplaceAll: 'subject=' with: '')) last
]

{ #category : #accessing }
TLSCertificate >> rawCert [

	^ rawCert
]

{ #category : #accessing }
TLSCertificate >> rawCert: anObject [

	rawCert := anObject
]

{ #category : #accessing }
TLSCertificate >> subject [

	^ subject
]

{ #category : #accessing }
TLSCertificate >> subject: anObject [

	subject := anObject
]

{ #category : #accessing }
TLSCertificate >> text [

	^ text
]

{ #category : #accessing }
TLSCertificate >> text: anObject [

	text := anObject
]
