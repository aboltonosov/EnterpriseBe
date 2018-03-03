﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		ВидыСчетаДляОчистки = Новый Массив;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовСКлиентами) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентами);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаАвансовПолученных) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыПолученные);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовПоВознаграждению) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыПоВознаграждению);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовСПоставщиками) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщиками);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаАвансовВыданных) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыВыданные);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовПоПретензиям) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыПоПретензиям);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовСКлиентамиТара) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентамиТара);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетУчетаРасчетовСПоставщикамиТара) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщикамиТара);
		КонецЕсли;
		
		Если ВидыСчетаДляОчистки.Количество() Тогда
			РегистрыСведений.СчетаРеглУчетаТребующиеНастройки.ОчиститьПриЗаписиАналитикиУчета(Ссылка, ВидыСчетаДляОчистки);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли