﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(
		ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВыработкаНМА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСерверУТ.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура СформироватьЗаданияКЗакрытиюМесяца()

	УчетОСВызовСервера.СформироватьЗаданиеАмортизацияНМА(
		ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли