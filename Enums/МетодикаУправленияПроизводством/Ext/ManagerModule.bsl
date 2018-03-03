﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст подсказки по методике управления производством
//
// Параметры:
//  Методика - ПеречислениеСсылка.МетодикаУправленияПроизводством - методика управления производством.
// 
// Возвращаемое значение:
//  Строка - подсказка по методике управления производством.
//
Функция ПодсказкаПоМетодике(Методика) Экспорт
	
	Если Методика = Перечисления.МетодикаУправленияПроизводством.ПланированиеПроизводственныхРесурсов Тогда
		
		Возврат НСтр("ru = 'График производства рассчитывается на основе доступности видов рабочих центров и потребности в материалах. Этапам назначаются сроки выполнения.'");
		
	ИначеЕсли Методика = Перечисления.МетодикаУправленияПроизводством.ПланированиеПотребностиВМатериалах Тогда
		
		Возврат НСтр("ru = 'Расчет графика производства выполняется с учетом потребности в материалах. Виды рабочих центров не используются при расчете графика. Этапам назначаются сроки выполнения.'");
		
	Иначе
		
		Возврат НСтр("ru = 'График производства не рассчитывается. Сроки выполнения этапов не назначаются, этапы выполняются согласно очереди.'");
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли