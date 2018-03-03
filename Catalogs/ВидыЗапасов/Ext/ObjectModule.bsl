﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ВидыЗапасов") Тогда
		
		Если Справочники.ВидыЗапасов.ПолучитьРеквизитыВидаЗапасов(ДанныеЗаполнения).РеализацияЗапасовДругойОрганизации Тогда
			Текст = НСтр("ru = 'Выбранный вид запасов уже является реализацией запасов другой организации'");
			ВызватьИсключение Текст;	
		КонецЕсли;
		
		РеализацияЗапасовДругойОрганизации = Истина;
		ВидЗапасовВладельца = ДанныеЗаполнения;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПроверятьКомитента = (ТипЗапасов = Перечисления.ТипыЗапасов.КомиссионныйТовар);
	//++ НЕ УТ
	Если ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца Тогда
		ПроверятьКомитента = Истина;
	КонецЕсли;
	//-- НЕ УТ
	Если Не ПроверятьКомитента Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Комитент");
	КонецЕсли;
	
	Если ТипЗапасов <> Перечисления.ТипыЗапасов.КомиссионныйТовар Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	ПроверятьПоставщика = Ложь;
	//++ НЕ УТ
	Если ТипЗапасов = Перечисления.ТипыЗапасов.МатериалДавальца Тогда
		ПроверятьПоставщика = Истина;
	КонецЕсли;
	//-- НЕ УТ
	Если Не ПроверятьПоставщика Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Поставщик");
	КонецЕсли;
	
	Если Не РеализацияЗапасовДругойОрганизации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидЗапасовВладельца");
		МассивНепроверяемыхРеквизитов.Добавить("СпособПередачиТоваров");
	КонецЕсли;
	
	Если РеализацияЗапасовДругойОрганизации Тогда
		
		Реквизиты = Справочники.ВидыЗапасов.ПолучитьРеквизитыВидаЗапасов(ВидЗапасовВладельца);
		Если Реквизиты.РеализацияЗапасовДругойОрганизации Тогда
			Текст = НСтр("ru = 'Указан вид запасов являющийся реализацией запасов другой организации'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Ссылка,
				"ВидЗапасовВладельца",
				,
				Отказ);
		КонецЕсли;
		
		Если Реквизиты.Организация = Организация Тогда
			Текст = НСтр("ru = 'Организация равна организации - владельцу товара'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Организация",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если РеализацияЗапасовДругойОрганизации Тогда
		Если СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию ТОГДА
			ТекущийТипЗапасов = Перечисления.ТипыЗапасов.КомиссионныйТовар;
		Иначе
			ТекущийТипЗапасов = Перечисления.ТипыЗапасов.Товар;
		КонецЕсли;
		Если ТипЗапасов <> ТекущийТипЗапасов Тогда
			ТипЗапасов = ТекущийТипЗапасов;
		КонецЕсли;
	КонецЕсли;
	
	ОчищатьКомитента = ТипЗапасов <> Перечисления.ТипыЗапасов.КомиссионныйТовар;
	//++ НЕ УТ
	Если ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца 
		ИЛИ ТипЗапасов = Перечисления.ТипыЗапасов.МатериалДавальца Тогда
		ОчищатьКомитента = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	Если ОчищатьКомитента 
		 И (ЗначениеЗаполнено(Комитент) ИЛИ Комитент <> Неопределено) Тогда
		Комитент = Неопределено;
	КонецЕсли;
	
	Если ТипЗапасов <> Перечисления.ТипыЗапасов.КомиссионныйТовар Тогда
		Если ЗначениеЗаполнено(Соглашение) Тогда
			Соглашение = Неопределено;
		КонецЕсли;
		Если ЗначениеЗаполнено(Валюта) Тогда
			Валюта = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Поставщик) ИЛИ Не ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПоставщикам"))
	 И Поставщик <> Неопределено Тогда
		Поставщик = Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контрагент) И Контрагент <> Неопределено Тогда
		Контрагент = Неопределено;
	КонецЕсли;
	
	НаименованиеВидаЗапасов = Справочники.ВидыЗапасов.ПолучитьНаименованиеВидаЗапасов(ЭтотОбъект);
	Если Наименование <> НаименованиеВидаЗапасов Тогда
		Наименование = НаименованиеВидаЗапасов;
	КонецЕсли;
	
	Если Не РеализацияЗапасовДругойОрганизации
	   И ЗначениеЗаполнено(ВидЗапасовВладельца) Тогда
		ВидЗапасовВладельца = Неопределено;
	КонецЕсли;
		
	Если Не РеализацияЗапасовДругойОрганизации Тогда
		Если ПометкаУдаления Тогда
			УдалитьАналитикуВидовЗапасов();
			ПометитьНаУдалениеВидыЗапасовИнтеркомпани();
		ИначеЕсли Не ЭтоНовый() Тогда
			СоздатьАналитикуВидовЗапасов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура УдалитьАналитикуВидовЗапасов()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеРегистра.Организация КАК Организация,
	|	ДанныеРегистра.ТипЗапасов КАК ТипЗапасов,
	|	ДанныеРегистра.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ДанныеРегистра.Поставщик КАК Поставщик,
	|	ДанныеРегистра.Соглашение КАК Соглашение,
	|	ДанныеРегистра.Валюта КАК Валюта,
	|	ДанныеРегистра.АналитикаПредназначения КАК АналитикаПредназначения,
	|	ДанныеРегистра.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДанныеРегистра.Контрагент КАК Контрагент,
	|	ДанныеРегистра.Договор КАК Договор
	|ИЗ
	|	РегистрСведений.АналитикаВидовЗапасов КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики = &ВидЗапасов
	|");
	Запрос.УстановитьПараметр("ВидЗапасов", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = РегистрыСведений.АналитикаВидовЗапасов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьАналитикуВидовЗапасов()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.Организация КАК Организация,
	|	ДанныеСправочника.ТипЗапасов КАК ТипЗапасов,
	|	ДанныеСправочника.Комитент КАК Комитент,
	|	ДанныеСправочника.Контрагент КАК Контрагент,
	|	ДанныеСправочника.Соглашение КАК Соглашение,
	|	ДанныеСправочника.Договор КАК Договор,
	|	ДанныеСправочника.Валюта КАК Валюта,
	|	ДанныеСправочника.НалогообложениеНДС КАК НалогообложениеНДС,
	|	Неопределено КАК НалогообложениеОрганизации,
	|	ВЫБОР КОГДА ДанныеСправочника.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) ТОГДА
	|		ДанныеСправочника.Комитент
	|	ИНАЧЕ
	|		ДанныеСправочника.Поставщик
	|	КОНЕЦ КАК Поставщик,
	|	ДанныеСправочника.Предназначение КАК Предназначение,
	|	ДанныеСправочника.Менеджер КАК Менеджер,
	|	ДанныеСправочника.Подразделение КАК Подразделение,
	|	ДанныеСправочника.Сделка КАК Сделка,
	|	Ложь КАК ОбособленныйУчетТоваровПоСделке,
	|	Неопределено КАК ВариантОбособленногоУчетаТоваров,
	|	ДанныеСправочника.ГруппаФинансовогоУчета,
	|	ДанныеСправочника.ГруппаПродукции
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаВидовЗапасов КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|ГДЕ
	|	ДанныеСправочника.Ссылка = &ВидЗапасов
	|	И ДанныеРегистра.КлючАналитики ЕСТЬ NULL
	|");
	Запрос.УстановитьПараметр("ВидЗапасов", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		СтруктураВидЗапасов = Справочники.ВидыЗапасов.СтруктураВидаЗапасов(
			Выборка.Организация,
			Неопределено, // Хозяйственная операция
			Выборка);
		
		МенеджерЗаписи = РегистрыСведений.АналитикаВидовЗапасов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураВидЗапасов);
		МенеджерЗаписи.КлючАналитики = Выборка.Ссылка;
		МенеджерЗаписи.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПометитьНаУдалениеВидыЗапасовИнтеркомпани()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.ВидЗапасовВладельца = &ВидЗапасов
	|	И Не ДанныеСправочника.ПометкаУдаления
	|");
	Запрос.УстановитьПараметр("ВидЗапасов", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
