﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Включает использование шаблона проводки (соответствия счетов / оборотов) в учетной политике.
// 
// Параметры
// 	УчетнаяПолитика - СправочникСсылка.УчетныеПолитики - Учетная политика, в которую необходимо включить шаблон проводки 
// 	ШаблонПроводки - СправочникСсыока.ШаблоныПроводокДляМеждународногоУчета,
// 					 СправочникСсылка.СоотвествияСчетовМеждународногоУчета
// 					 СправочникСсылка.СоотвествияОборотовМеждународногоУчета - Шаблон проводки (соответствия счетов / оборотов)
//
Процедура ВключитьВУчетнуюПолитику(УчетнаяПолитика, ШаблонПроводки) Экспорт
	
	НаборЗаписей = РегистрыСведений.ПравилаОтраженияВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	НаборЗаписей.Отбор.ШаблонПроводки.Установить(ШаблонПроводки);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.УчетнаяПолитика = УчетнаяПолитика;
	НоваяЗапись.ШаблонПроводки = ШаблонПроводки;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
